/datum/disease_property/symptom/heal
	name = "Basic Healing (does nothing)" //warning for adminspawn viruses
	desc = "You should not be seeing this."
	level = 0 //not obtainable
	var/passive_message = "" //random message to infected but not actively healing people
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

/datum/disease_property/symptom/heal/proc/heal(mob/living/M, actual_power)
	return TRUE

/datum/disease_property/symptom/heal/proc/passive_message_condition(mob/living/M)
	return TRUE


/datum/disease_property/symptom/heal/starlight
	name = "Starlight Condensation"
	desc = "The virus reacts to direct starlight, producing regenerative chemicals. Works best against toxin-based damage."
	level = 6
	passive_message = "<span class='notice'>You miss the feeling of starlight on your skin.</span>"
	var/nearspace_penalty = 0.3
	threshold_desc = "<b>Stage Speed 6:</b> Increases healing speed.<br>\
					  <b>Transmission 6:</b> Removes penalty for only being close to space."

/datum/disease_property/symptom/heal/starlight/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_BETA])
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

/datum/disease_property/symptom/heal/chem
	name = "Toxolysis"
	stealth = 0
	resistance = -2
	stage_speed = 2
	transmittable = -2
	level = 7
	var/food_conversion = FALSE
	desc = "The virus rapidly breaks down any foreign chemicals in the bloodstream."
	threshold_desc = "<b>Resistance 7:</b> Increases chem removal speed.<br>\
					  <b>Stage Speed 6:</b> Consumed chemicals nourish the host."

/datum/disease_property/symptom/heal/chem/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 6)
		food_conversion = TRUE
	if(A.properties["resistance"] >= 7)
		power = 2

/datum/disease_property/symptom/heal/chem/Heal(mob/living/M, datum/disease/advance/A, actual_power)
	for(var/datum/reagent/R in M.reagents.reagent_list) //Not just toxins!
		M.reagents.remove_reagent(R.type, actual_power)
		if(food_conversion)
			M.adjust_nutrition(0.3)
		if(prob(2))
			to_chat(M, "<span class='notice'>You feel a mild warmth as your blood purifies itself.</span>")
	return 1



/datum/disease_property/symptom/heal/metabolism
	name = "Metabolic Boost"
	stealth = -1
	resistance = -2
	stage_speed = 2
	transmittable = 1
	level = 7
	var/triple_metabolism = FALSE
	var/reduced_hunger = FALSE
	desc = "The virus causes the host's metabolism to accelerate rapidly, making them process chemicals twice as fast,\
	 but also causing increased hunger."
	threshold_desc = "<b>Stealth 3:</b> Reduces hunger rate.<br>\
					  <b>Stage Speed 10:</b> Chemical metabolization is tripled instead of doubled."

/datum/disease_property/symptom/heal/metabolism/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 10)
		triple_metabolism = TRUE
	if(A.properties["stealth"] >= 3)
		reduced_hunger = TRUE

/datum/disease_property/symptom/heal/metabolism/Heal(mob/living/carbon/C, datum/disease/advance/A, actual_power)
	if(!istype(C))
		return
	C.reagents.metabolize(C, can_overdose=TRUE) //this works even without a liver; it's intentional since the virus is metabolizing by itself
	if(triple_metabolism)
		C.reagents.metabolize(C, can_overdose=TRUE)
	C.overeatduration = max(C.overeatduration - 2, 0)
	var/lost_nutrition = 9 - (reduced_hunger * 5)
	C.adjust_nutrition(-lost_nutrition * HUNGER_FACTOR) //Hunger depletes at 10x the normal speed
	if(prob(2))
		to_chat(C, "<span class='notice'>You feel an odd gurgle in your stomach, as if it was working much faster than normal.</span>")
	return 1

/datum/disease_property/symptom/heal/darkness
	name = "Nocturnal Regeneration"
	desc = "The virus is able to mend the host's flesh when in conditions of low light, repairing physical damage. More effective against brute damage."
	stealth = 2
	resistance = -1
	stage_speed = -2
	transmittable = -1
	level = 6
	passive_message = "<span class='notice'>You feel tingling on your skin as light passes over it.</span>"
	threshold_desc = "<b>Stage Speed 8:</b> Doubles healing speed."

/datum/disease_property/symptom/heal/darkness/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 8)
		power = 2

/datum/disease_property/symptom/heal/darkness/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	var/light_amount = 0
	if(isturf(M.loc)) //else, there's considered to be no light
		var/turf/T = M.loc
		light_amount = min(1,T.get_lumcount()) - 0.5
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			return power

/datum/disease_property/symptom/heal/darkness/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = 2 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	if(prob(5))
		to_chat(M, "<span class='notice'>The darkness soothes and mends your wounds.</span>")

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len * 0.5, null, BODYPART_ORGANIC)) //more effective on brute
			M.update_damage_overlays()
	return 1

/datum/disease_property/symptom/heal/darkness/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss())
		return TRUE
	return FALSE

/datum/disease_property/symptom/heal/coma
	name = "Regenerative Coma"
	desc = "The virus causes the host to fall into a coma when severely damaged, then rapidly fixes the damage."
	level = 8
	passive_message = "<span class='notice'>The pain from your wounds makes you feel oddly sleepy...</span>"
	var/fake_death = FALSE
	var/active_coma = FALSE //to prevent multiple coma procs
	threshold_desc = "<b>GAMMA:</b> Host appears dead when falling into a coma.<br>\
					  <b>Stage Speed 7:</b> Increases healing speed."

/datum/disease_property/symptom/heal/coma/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_GAMMA])
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
	if(disease.mutators[DISEASE_MUTATOR_ALPHA])
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
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		temp_immune = TRUE
	else
		temp_immune = FALSE
	if(disease.mutators[DISEASE_MUTATOR_GAMMA])
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
	var/cellular_damage = FALSE
	threshold_desc = "<b>Transmission 6:</b> Additionally heals cellular damage.<br>\
					  <b>Resistance 7:</b> Increases healing speed."

/datum/disease_property/symptom/heal/radiation/update_mutators()
	if(A.properties["resistance"] >= 7)
		power = 2
	if(A.properties["transmittable"] >= 6)
		cellular_damage = TRUE

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
	return 1
