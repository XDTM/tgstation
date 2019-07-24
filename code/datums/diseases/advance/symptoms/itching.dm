/datum/disease_property/symptom/itching
	name = "Itching"
	desc = "The virus irritates the skin, causing annoying itching."
	symptom_delay_min = 30
	symptom_delay_max = 80
	var/severe = FALSE
	threshold_desc = "<b>BETA:</b> Makes itching more annoying."

/datum/disease_property/symptom/itching/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		severe = TRUE
	else
		severe = FALSE

/datum/disease_property/symptom/itching/activate()
	var/mob/living/carbon/M = disease.affected_mob
	M.apply_status_effect(/datum/status_effect/itching, null, 450, severe)
