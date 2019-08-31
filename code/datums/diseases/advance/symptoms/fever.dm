///
/datum/disease_property/symptom/fever
	name = "Fever"
	desc = "The disease causes a febrile response from the host, raising its natural body temperature."
	symptom_delay_min = 5
	symptom_delay_max = 10
	var/prevent_cooling = FALSE
	var/fevering = FALSE
	threshold_desc = "<b>BETA:</b> Prevents the host from cooling down on their own.<br>\
					  <b>EPSILON:</b> The disease causes extreme amount of heat, boiling the host from the inside."

/datum/disease_property/symptom/fever/update_mutators()	
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		prevent_cooling = TRUE
	else
		prevent_cooling = FALSE
		REMOVE_TRAIT(disease.affected_mob, TRAIT_NO_STABILIZE_HEAT, FEVER_TRAIT)
	multiplier = 1
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_EPSILON))
		multiplier += 9

/datum/disease_property/symptom/fever/activate()
	var/mob/living/carbon/M = disease.affected_mob
	if(message_cooldown())
		if(!prevent_cooling || disease.stage < 4)
			to_chat(M, "<span class='warning'>[pick("You feel hot.", "You feel like you're burning.")]</span>")
		else
			to_chat(M, "<span class='warning'>[pick("You feel too hot.", "You feel like your blood is boiling.")]</span>")
	heat(M)

/datum/disease_property/symptom/fever/on_stage_increase(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 4)
		if(!fevering)
			M.natural_bodytemperature += (40 * multiplier)
			fevering = TRUE
		if(prevent_cooling)
			ADD_TRAIT(M, TRAIT_NO_STABILIZE_HEAT, FEVER_TRAIT)

/datum/disease_property/symptom/fever/on_stage_decrease(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 3)
		if(fevering)
			M.natural_bodytemperature -= (40 * multiplier)
			fevering = FALSE
		REMOVE_TRAIT(M, TRAIT_NO_STABILIZE_HEAT, FEVER_TRAIT)

/datum/disease_property/symptom/fever/on_end()
	var/mob/living/carbon/M = disease.affected_mob
	if(fevering)
		M.natural_bodytemperature -= (40 * multiplier)
		fevering = FALSE
	REMOVE_TRAIT(M, TRAIT_NO_STABILIZE_HEAT, FEVER_TRAIT)

/datum/disease_property/symptom/fever/proc/heat(mob/living/M)
	var/get_heat = 40 * multiplier
	M.adjust_bodytemperature(get_heat)
