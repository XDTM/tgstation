/*!
	Makes the affected mob confused for short periods of time.
*/
/datum/disease_property/symptom/confusion
	name = "Confusion"
	desc = "The virus interferes with the proper function of the neural system, leading to bouts of confusion and erratic movement."
	level = 4
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/brain_damage = FALSE
	var/
	threshold_desc = "<b>ALPHA:</b> Increases confusion duration.<br>\
					  <b>BETA:</b> Causes brain damage over time."

/datum/disease_property/symptom/confusion/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_ALPHA])
		multiplier = 1.5
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		brain_damage = TRUE

/datum/disease_property/symptom/confusion/activate()
	var/mob/living/carbon/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("Your head hurts.", "Your mind blanks for a moment.", "You feel dizzy.")]</span>")
		else
			to_chat(M, "<span class='userdanger'>You can't think straight!</span>")
			M.confused = min(M.confused + (8 * multiplier), 100)
			if(brain_damage)
				M.adjustBrainLoss(3 * multiplier, 80)
				M.updatehealth()
