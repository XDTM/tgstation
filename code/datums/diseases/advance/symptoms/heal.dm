/datum/disease_property/symptom/heal
	name = "Basic Healing (does nothing)" //warning for adminspawn viruses
	desc = "You should not be seeing this."
	level = 0
	var/passive_message = "" //Random message to the host warning them that the symptom exists
	threshold_desc = "<b>Stage Speed 6:</b> Doubles healing speed.<br>\
					  <b>Stealth 4:</b> Healing will no longer be visible to onlookers."

/datum/disease_property/symptom/heal/on_process()
	..()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(4, 5)
			var/effectiveness = can_heal()
			if(!effectiveness)
				if(passive_message && passive_message_condition(M) && message_cooldown())
					to_chat(M, passive_message)
				return
			else
				heal(M, effectiveness)
	return

///Checks if the disease meets the healing conditions, returns the heal multiplier if so.
/datum/disease_property/symptom/heal/proc/can_heal()
	return multiplier

///Applies the symptom healing effect, multiplied by actual_power
/datum/disease_property/symptom/heal/proc/heal(mob/living/M, actual_power)
	return TRUE

///The condition that has to be met to trigger the passive message
/datum/disease_property/symptom/heal/proc/passive_message_condition(mob/living/M)
	return TRUE

///Heals people close to or in space
/datum/disease_property/symptom/heal/starlight
	name = "Starlight Condensation"
	desc = "The virus reacts to direct starlight, producing regenerative chemicals. Works best against toxin-based damage."
	level = 6
	passive_message = "<span class='notice'>You miss the feeling of starlight on your skin.</span>"
	var/nearspace_penalty = 0.3
	threshold_desc = "<b>Stage Speed 6:</b> Increases healing speed.<br>\
					  <b>Transmission 6:</b> Removes penalty for only being close to space."

/datum/disease_property/symptom/heal/starlight/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA])
		nearspace_penalty = 1
	else
		nearspace_penalty = initial(nearspace_penalty)
	if(A.properties["stage_rate"] >= 6)
		power = 2

/datum/disease_property/symptom/heal/starlight/can_heal()
	var/mob/living/M = disease.affected_mob
	if(istype(get_turf(M), /turf/open/space))
		return power
	else
		for(var/turf/T in view(M, 2))
			if(istype(T, /turf/open/space))
				return power * nearspace_penalty

/datum/disease_property/symptom/heal/starlight/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = actual_power
	if(M.getToxLoss() && message_cooldown())
		to_chat(M, "<span class='notice'>Your skin tingles as the starlight seems to heal you.</span>")

	M.adjustToxLoss(-(4 * heal_amt)) //most effective on toxins

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()
	return 1

/datum/disease_property/symptom/heal/starlight/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss() || M.getToxLoss())
		return TRUE
	return FALSE

///Removes chems from the body
/datum/disease_property/symptom/heal/chem
	name = "Phagocyte"
	var/food_conversion = FALSE
	desc = "The virus rapidly breaks down any foreign chemicals in the bloodstream."
	threshold_desc = "<b>BETA:</b> Converts reagents into nutrition for the host."

/datum/disease_property/symptom/heal/chem/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA])
		food_conversion = TRUE
	else
		food_conversion = FALSE

/datum/disease_property/symptom/heal/chem/heal(mob/living/M, actual_power)
	for(var/datum/reagent/R in M.reagents.reagent_list) //Not just toxins!
		M.reagents.remove_reagent(R.type, actual_power)
		if(food_conversion)
			M.adjust_nutrition(0.3)
		if(message_cooldown())
			to_chat(M, "<span class='notice'>You feel a mild warmth as your blood purifies itself.</span>")

///Independently processes reagents as if it was a second liver
/datum/disease_property/symptom/heal/metabolism
	name = "Parallel Metabolization"
	var/triple_metabolism = FALSE
	var/reduced_hunger = FALSE
	desc = "The virus causes the host's metabolism to accelerate rapidly, making them metabolize twice as fast,\
	 but also causing increased hunger."
	threshold_desc = "<b>ALPA:</b> Reduces hunger caused by the symptom.<br>\
					  <b>GAMMA:</b> Chemical metabolization is tripled instead of doubled."

/datum/disease_property/symptom/heal/metabolism/update_mutators()
	if(disease.properties[DISEASE_MUTATOR_GAMMA])
		triple_metabolism = TRUE
	else
		triple_metabolism = FALSE
	if(disease.properties[DISEASE_MUTATOR_ALPHA])
		reduced_hunger = TRUE
	else
		reduced_hunger = FALSE

/datum/disease_property/symptom/heal/metabolism/heal(mob/living/carbon/C, actual_power)
	if(!istype(C))
		return
	C.reagents.metabolize(C, can_overdose=TRUE) //this works even without a liver; it's intentional since the virus is metabolizing by itself
	if(triple_metabolism)
		C.reagents.metabolize(C, can_overdose=TRUE)
	C.overeatduration = max(C.overeatduration - 2, 0)
	var/lost_nutrition = 9 - (reduced_hunger * 5)
	C.adjust_nutrition(-lost_nutrition * HUNGER_FACTOR) //Hunger depletes at 10x the normal speed, 5x with the mutator
	if(message_cooldown())
		to_chat(C, "<span class='notice'>You feel an odd gurgle coming from near your stomach.</span>")

/datum/disease_property/symptom/heal/darkness
	name = "Nocturnal Regeneration"
	desc = "The virus is able to mend the host's flesh when in conditions of low light, repairing physical damage. More effective against brute damage."
	passive_message = "<span class='notice'>You feel tingling on your skin as light passes over it.</span>"
	threshold_desc = "<b>GAMMA:</b> Additionally gives night vision to the host."
	var/night_vision = FALSE

/datum/disease_property/symptom/heal/darkness/update_mutators()
	if(disease.properties[DISEASE_MUTATOR_GAMMA])
		night_vision = TRUE
	else
		night_vision = FALSE


/datum/disease_property/symptom/heal/darkness/on_stage_increase(new_stage, prev_stage)
	if(night_vision && new_stage >= 5)
		ADD_TRAIT(disease.affected_mob, TRAIT_NIGHT_VISION, NOCTURNAL_REGEN_TRAIT)

/datum/disease_property/symptom/heal/darkness/on_stage_decrease(new_stage, prev_stage)
	if(new_stage <= 4)
		REMOVE_TRAIT(disease.affected_mob, TRAIT_NIGHT_VISION, NOCTURNAL_REGEN_TRAIT)

/datum/disease_property/symptom/heal/darkness/on_end()
	REMOVE_TRAIT(disease.affected_mob, TRAIT_NIGHT_VISION, NOCTURNAL_REGEN_TRAIT)

/datum/disease_property/symptom/heal/darkness/can_heal()
	var/mob/living/M = disease.affected_mob
	var/light_amount = 0
	if(isturf(M.loc)) //else, there's considered to be no light
		var/turf/T = M.loc
		light_amount = min(1,T.get_lumcount()) - 0.5
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			return multiplier

/datum/disease_property/symptom/heal/darkness/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = 2 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	if(message_cooldown())
		to_chat(M, "<span class='notice'>The darkness soothes and mends your wounds.</span>")

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len * 0.5, null, BODYPART_ORGANIC)) //more effective on brute
			M.update_damage_overlays()

/datum/disease_property/symptom/heal/darkness/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss())
		return TRUE
	return FALSE

/datum/disease_property/symptom/heal/coma
	name = "Regenerative Coma"
	desc = "The virus causes the host to fall into a coma when severely damaged, then rapidly fixes the damage."
	passive_message = "<span class='notice'>The pain from your wounds makes you feel oddly sleepy...</span>"
	var/fake_death = FALSE
	var/active_coma = FALSE //to prevent multiple coma procs
	threshold_desc = "<b>GAMMA:</b> Host appears dead when falling into a coma.<br>\
					  <b>Stage Speed 7:</b> Increases healing speed."

/datum/disease_property/symptom/heal/coma/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_GAMMA])
		fake_death = TRUE
	else
		fake_death = FALSE

/datum/disease_property/symptom/heal/coma/can_heal()
	var/mob/living/M = disease.affected_mob
	if(HAS_TRAIT(M, TRAIT_DEATHCOMA))
		return multiplier
	else if(M.IsUnconscious() || M.stat == UNCONSCIOUS)
		return multiplier * 0.9
	else if(M.stat == SOFT_CRIT)
		return multiplier * 0.5
	else if(M.IsSleeping())
		return multiplier * 0.25
	else if(M.getBruteLoss() + M.getFireLoss() >= 60 && !active_coma)
		to_chat(M, "<span class='warning'>You feel yourself slip into a regenerative coma...</span>")
		active_coma = TRUE
		addtimer(CALLBACK(src, .proc/coma, M), 60)

/datum/disease_property/symptom/heal/coma/proc/coma(mob/living/M)
	if(fake_death)
		M.emote("deathgasp")
		M.fakedeath("regenerative_coma")
	else
		ADD_TRAIT(M, TRAIT_DEATHCOMA, "regen_coma")
	M.update_stat()
	M.update_mobility()
	addtimer(CALLBACK(src, .proc/uncoma, M), 300)

/datum/disease_property/symptom/heal/coma/proc/uncoma(mob/living/M)
	if(!active_coma)
		return
	active_coma = FALSE
	if(fake_death)
		M.cure_fakedeath("regenerative_coma")
	else
		REMOVE_TRAIT(M, TRAIT_DEATHCOMA, "regen_coma")
	M.update_stat()
	M.update_mobility()

/datum/disease_property/symptom/heal/coma/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = 4 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1)

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()

	if(active_coma && M.getBruteLoss() + M.getFireLoss() == 0)
		uncoma(M)

/datum/disease_property/symptom/heal/coma/passive_message_condition(mob/living/M)
	if((M.getBruteLoss() + M.getFireLoss()) > 30)
		return TRUE
	return FALSE

/datum/disease_property/symptom/heal/water
	name = "Tissue Hydration"
	desc = "The virus uses excess water inside and outside the body to repair damaged tissue cells. More effective when using holy water and against burns."
	level = 6
	passive_message = "<span class='notice'>Your skin feels oddly dry...</span>"
	var/absorption_coeff = 1
	threshold_desc = "<b>ALPHA:</b> Water is consumed more efficiently."

/datum/disease_property/symptom/heal/water/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_ALPHA])
		absorption_coeff = 0.25
	else
		absorption_coeff = initial(absorption_coeff)

/datum/disease_property/symptom/heal/water/can_heal()
	. = 0
	var/mob/living/M = disease.affected_mob
	if(M.fire_stacks < 0)
		M.fire_stacks = min(M.fire_stacks + 1 * absorption_coeff, 0)
		. += multiplier
	if(M.reagents.has_reagent(/datum/reagent/water/holywater, needs_metabolizing = FALSE))
		M.reagents.remove_reagent(/datum/reagent/water/holywater, 0.5 * absorption_coeff)
		. += multiplier * 0.75
	else if(M.reagents.has_reagent(/datum/reagent/water, needs_metabolizing = FALSE))
		M.reagents.remove_reagent(/datum/reagent/water, 0.5 * absorption_coeff)
		. += multiplier * 0.5

/datum/disease_property/symptom/heal/water/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = 2 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC) 

	if(!parts.len)
		return

	if(message_cooldown())
		to_chat(M, "<span class='notice'>You feel yourself absorbing the water around you to soothe your damaged skin.</span>")

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len * 0.5, heal_amt/parts.len, null, BODYPART_ORGANIC)) //more effective on burns
			M.update_damage_overlays()

	return 1

/datum/disease_property/symptom/heal/water/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss())
		return TRUE
	return FALSE

/datum/disease_property/symptom/heal/plasma
	name = "Plasma Fixation"
	desc = "The virus draws plasma from the atmosphere and from inside the body to heal and stabilize body temperature."
	level = 8
	passive_message = "<span class='notice'>You feel an odd attraction to plasma.</span>"
	var/temp_immune = FALSE
	var/tox_immune = FALSE
	threshold_desc = "<b>BETA:</b> Grants immunity from toxins while in contact with plasma.<br>\
					  <b>GAMMA:</b> Grants immunity from heat and cold while in contact with plasma."

/datum/disease_property/symptom/heal/plasma/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		temp_immune = TRUE
	else
		temp_immune = FALSE
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_GAMMA))
		tox_immune = TRUE
	else
		tox_immune = FALSE

/datum/disease_property/symptom/heal/plasma/on_process()
	..()
	if(can_heal)
		if(temp_immune)
			ADD_TRAIT(disease.affected_mob, TRAIT_RESISTHEAT, "plasma_fixation")
			ADD_TRAIT(disease.affected_mob, TRAIT_RESISTCOLD, "plasma_fixation")
		if(tox_immune)
			ADD_TRAIT(disease.affected_mob, TRAIT_TOXIMMUNE, "plasma_fixation")
	else
		if(temp_immune)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_RESISTHEAT, "plasma_fixation")
			REMOVE_TRAIT(disease.affected_mob, TRAIT_RESISTCOLD, "plasma_fixation")
		if(tox_immune)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_TOXIMMUNE, "plasma_fixation")

/datum/disease_property/symptom/heal/plasma/on_end()
	if(temp_immune)
		REMOVE_TRAIT(disease.affected_mob, TRAIT_RESISTHEAT, "plasma_fixation")
		REMOVE_TRAIT(disease.affected_mob, TRAIT_RESISTCOLD, "plasma_fixation")
	if(tox_immune)
		REMOVE_TRAIT(disease.affected_mob, TRAIT_TOXIMMUNE, "plasma_fixation")

/datum/disease_property/symptom/heal/plasma/can_heal()
	var/mob/living/M = disease.affected_mob
	var/datum/gas_mixture/environment
	var/list/gases

	. = 0

	if(M.loc)
		environment = M.loc.return_air()
	if(environment)
		gases = environment.gases
		if(gases["plasma"] && gases["plasma"][MOLES] > gases["plasma"][GAS_META][META_GAS_MOLES_VISIBLE]) //if there's enough plasma in the air to see
			. += 0.5
	if(M.reagents.has_reagent(/datum/reagent/toxin/plasma, needs_metabolizing = FALSE))
		M.reagents.remove_reagent(/datum/reagent/toxin/plasma, 0.4)
		. += 0.75

/datum/disease_property/symptom/heal/plasma/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = 4 * actual_power

	if(message_cooldown())
		to_chat(M, "<span class='notice'>You feel yourself absorbing plasma inside and around you...</span>")

	M.adjustToxLoss(-heal_amt)

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)
	if(!parts.len)
		return
	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()


/datum/disease_property/symptom/heal/radiation
	name = "Radioactive Resonance"
	desc = "The virus uses radiation to fix damage through local cellular mutations."
	level = 6
	passive_message = "<span class='notice'>Your skin glows faintly.</span>"
	var/glow = FALSE
	var/obj/effect/dummy/viral_glow/glow_object
	threshold_desc = "<b>ALPHA:</b> Makes the host glow while active."

/datum/disease_property/symptom/heal/radiation/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_ALPHA])
		glow = TRUE
	else
		glow = FALSE

/datum/disease_property/symptom/heal/radiation/on_process()
	..()
	if(glow && disease.stage >= 5)
		var/light_power = CEILING(can_heal() * 3, 1)
		if(light_power)
			if(!glow_object)
				glow_object = new(disease.affected_mob)
			glow_object.light_range = light_power
		else
			if(glow_object)
				qdel(glow_object)

/datum/disease_property/symptom/heal/radiation/on_end()
	if(glow_object)
		qdel(glow_object)

/datum/disease_property/symptom/heal/radiation/can_heal()
	var/mob/living/M = disease.affected_mob
	switch(M.radiation)
		if(0)
			return FALSE
		if(1 to RAD_MOB_SAFE)
			return 0.25
		if(RAD_MOB_SAFE to RAD_MOB_HAIRLOSS)
			return 0.5
		if(RAD_MOB_HAIRLOSS to RAD_MOB_MUTATE)
			return 0.75
		if(RAD_MOB_MUTATE to RAD_MOB_KNOCKDOWN)
			return 1.5
		else
			return 2

/datum/disease_property/symptom/heal/radiation/heal(mob/living/carbon/M, actual_power)
	var/heal_amt = actual_power

	M.adjustCloneLoss(-heal_amt * 0.5)

	M.adjustToxLoss(-(2 * heal_amt))

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	if(message_cooldown())
		to_chat(M, "<span class='notice'>Your skin glows faintly, and you feel your wounds mending themselves.</span>")

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()

/obj/effect/dummy/viral_glow
	name = "viral glow"
	desc = "Tell a coder if you're seeing this."
	icon_state = "nothing"
	light_color = "#5DCA31"
	light_range = 0

/obj/effect/dummy/viral_glow/Initialize()
	. = ..()
	if(!isliving(loc))
		return INITIALIZE_HINT_QDEL
