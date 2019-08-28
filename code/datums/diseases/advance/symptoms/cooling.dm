/datum/disease_property/symptom/cooling
	name = "Cooling"
	desc = "The disease inhibits the body's thermoregulation, cooling the body down."
	symptom_delay_min = 5
	symptom_delay_max = 10
	var/chilling = FALSE //checks if the base body temperature has been lowered already
	var/prevent_heating = FALSE //prevents natural thermoregulation
	var/ice_cube = FALSE
	threshold_desc = "<b>BETA:</b> Makes the user fully cold-blooded, unable to heat up on their own.<br>\
					  <b>DELTA:</b> Freezes the host solid at low enough temperatures."

/datum/disease_property/symptom/cooling/update_mutators()	
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		prevent_heating = TRUE
	else
		prevent_heating = FALSE
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_DELTA))
		ice_cube = TRUE
	else
		ice_cube = FALSE

/datum/disease_property/symptom/cooling/activate()
	var/mob/living/carbon/M = disease.affected_mob
	if(message_cooldown())
		if(!unsafe || disease.stage < 4)
			to_chat(M, "<span class='warning'>[pick("You feel cold.", "You shiver.")]</span>")
		else
			to_chat(M, "<span class='warning'>[pick("You feel your blood run cold.", "You feel ice in your veins.", "You feel like you can't heat up.", "You shiver violently." )]</span>")
	if((M.bodytemperature > BODYTEMP_COLD_DAMAGE_LIMIT) || unsafe)
		chill(M)

/datum/disease_property/symptom/cooling/on_stage_increase(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 4)
		if(!chilling)
			M.natural_bodytemperature -= (40 * multiplier)
			chilling = TRUE
		if(unsafe)
			ADD_TRAIT(M, TRAIT_NO_STABILIZE_COLD, COOLING_TRAIT)

/datum/disease_property/symptom/cooling/on_stage_decrease(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 3)
		if(chilling)
			M.natural_bodytemperature += (40 * multiplier)
			chilling = FALSE
		if(unsafe)
			REMOVE_TRAIT(M, TRAIT_NO_STABILIZE_COLD, COOLING_TRAIT)

/datum/disease_property/symptom/cooling/on_end()
	var/mob/living/carbon/M = disease.affected_mob
	if(chilling)
		M.natural_bodytemperature += (40 * multiplier)
		chilling = FALSE
	if(unsafe)
		REMOVE_TRAIT(M, TRAIT_NO_STABILIZE_COLD, COOLING_TRAIT)

/datum/disease_property/symptom/cooling/proc/chill(mob/living/M)
	var/get_cold = 40 * multiplier
	M.adjust_bodytemperature(-get_cold)
	if(M.bodytemperature < 50)
		M.apply_status_effect(/datum/status_effect/freon)
