///Gives NOBREATH to the host, making them immune to oxygen damage and stopping breathing
/datum/disease_property/symptom/oxygen
	name = "Self-Respiration"
	desc = "The disease rapidly synthesizes oxygen, effectively removing the need for breathing."
	var/nutrition = FALSE
	threshold_desc = "<b>GAMMA:</b>The disease also provides nutrition to the host's cells.<br>"

/datum/disease_property/symptom/oxygen/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_GAMMA))
		nutrition = TRUE
	else
		nutrition = FALSE

/datum/disease_property/symptom/oxygen/on_process()
	..()
	var/mob/living/carbon/M = disease.affected_mob
	if(disease.stage >= 4)
		if(message_cooldown())
			to_chat(M, "<span class='notice'>[pick("You realize you haven't been breathing.", "You don't feel the need to breathe.")]</span>")
		if(nutrition && (M.nutrition < NUTRITION_LEVEL_WELL_FED))
			M.adjust_nutrition(1)

/datum/disease_property/symptom/oxygen/activate()
	var/mob/living/carbon/M = disease.affected_mob
	switch(disease.stage)
		if(4, 5)
			if(message_cooldown())
				to_chat(M, "<span class='notice'>[pick("You realize you haven't been breathing.", "You don't feel the need to breathe.")]</span>")

/datum/disease_property/symptom/oxygen/on_stage_increase(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 4)
		ADD_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)

/datum/disease_property/symptom/oxygen/on_stage_decrease(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 3)
		REMOVE_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)

/datum/disease_property/symptom/oxygen/on_end()
	REMOVE_TRAIT(disease.affected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
