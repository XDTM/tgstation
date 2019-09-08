/datum/disease_property/symptom/neural_restoration
	name = "Neural Restoration"
	desc = "The disease strengthens the bonds between neurons, curing brain damage and healing minor traumas."
	symptom_delay_min = 6
	symptom_delay_max = 6
	var/restore_minor = FALSE
	var/trauma_heal_severe = FALSE
	threshold_desc = "<b>ALPHA:</b> The host recovers rapidly from minor ailments, like confusion.<br>\
					  <b>GAMMA:</b> Can regenerate severe and deep-rooted brain traumas."

/datum/disease_property/symptom/neural_restoration/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_ALPHA))
		restore_minor = TRUE
	else
		restore_minor = FALSE
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_GAMMA))
		trauma_heal_severe = TRUE
	else
		trauma_heal_severe = FALSE

/datum/disease_property/symptom/neural_restoration/on_process()
	..()
	var/mob/living/carbon/M = disease.affected_mob
	if(disease.stage >= 4 && restore_minor)
		M.dizziness = max(0, M.dizziness - 1)
		M.drowsyness = max(0, M.drowsyness - 1)
		M.slurring = max(0, M.slurring - 1)
		M.confused = max(0, M.confused - 1)
		M.drunkenness = max(M.drunkenness - 2, 0)
		M.hallucination = max(0, M.hallucination - 2)

/datum/disease_property/symptom/neural_restoration/activate()
	var/mob/living/M = disease.affected_mob
	if(disease.stage >= 5)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(prob(10))
				if(trauma_heal_severe)
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_LOBOTOMY)
				else
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)


