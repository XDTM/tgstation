///Lets the host survive indefinitely when in crit.
/datum/disease_property/symptom/life_support
	name = "Life Support"
	desc = "The disease provides the essential nutrition and oxygenation necessary for the host's survival when critically injured, stabilizing them indefinitely."
	symptom_delay_min = 25
	symptom_delay_max = 50
	var/no_death = FALSE
	var/no_crit = FALSE
	var/survival_counter = 45
	threshold_desc = "<b>DELTA:</b> Makes the host able to survive normally fatal amounts of damage, although they will still be incapacitated.<br>\
					  <b>EPSILON:</b> Allows the host to ignore critical injuries, allowing them to stay active until the disease runs out of reserves.<br>"

/datum/disease_property/symptom/life_support/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_DELTA))
		no_death = TRUE
	else
		no_death = FALSE
		if(disease.processing)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_NODEATH, DISEASE_TRAIT)
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_EPSILON))
		no_crit = TRUE
	else
		no_crit = FALSE
		if(disease.processing)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_NOHARDCRIT, DISEASE_TRAIT)

/datum/disease_property/symptom/life_support/on_process()
	..()
	if(no_crit && disease.stage >= 5)
		var/mob/living/carbon/M = disease.affected_mob
		if(M.health <= M.crit_threshold)
			survival_counter = max(0, survival_counter - 1)
			if(survival_counter == 0)
				to_chat(M, "<span class='userdanger'>Your body collapses, suddenly unable to sustain your injuries!")
				REMOVE_TRAIT(M, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
				REMOVE_TRAIT(M, TRAIT_NOHARDCRIT, DISEASE_TRAIT)
		else
			survival_counter = min(initial(survival_counter), survival_counter + 1)
			ADD_TRAIT(M, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
			ADD_TRAIT(M, TRAIT_NOHARDCRIT, DISEASE_TRAIT)
	

/datum/disease_property/symptom/life_support/on_stage_increase(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 5)
		ADD_TRAIT(M, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)
		if(no_death)
			ADD_TRAIT(M, TRAIT_NODEATH, DISEASE_TRAIT)
		if(no_crit)
			ADD_TRAIT(M, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
			ADD_TRAIT(M, TRAIT_NOHARDCRIT, DISEASE_TRAIT)

/datum/disease_property/symptom/life_support/on_stage_decrease(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 4)
		REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)
		REMOVE_TRAIT(M, TRAIT_NODEATH, DISEASE_TRAIT)
		REMOVE_TRAIT(M, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
		REMOVE_TRAIT(M, TRAIT_NOHARDCRIT, DISEASE_TRAIT)

/datum/disease_property/symptom/life_support/on_end()
	var/mob/living/carbon/M = disease.affected_mob
	REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)
	REMOVE_TRAIT(M, TRAIT_NODEATH, DISEASE_TRAIT)
	REMOVE_TRAIT(M, TRAIT_NOSOFTCRIT, DISEASE_TRAIT)
	REMOVE_TRAIT(M, TRAIT_NOHARDCRIT, DISEASE_TRAIT)
