/*!
	Shakes the affected mob's screen for short periods.
*/
/datum/disease_property/symptom/dizzy
	name = "Dizziness"
	desc = "The virus causes inflammation of the vestibular system, leading to bouts of dizziness."
	level = 4
	symptom_delay_min = 15
	symptom_delay_max = 40
	var/drugginess = FALSE
	threshold_desc = "<b>BETA:</b> Also causes druggy vision."

/datum/disease_property/symptom/dizzy/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		drugginess = TRUE
	else
		drugginess = FALSE

/datum/disease_property/symptom/dizzy/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You feel dizzy.", "Your head spins.")]</span>")
		else
			to_chat(M, "<span class='userdanger'>A wave of dizziness washes over you!</span>")
			M.Dizzy(5)
			if(drugginess)
				M.set_drugginess(5)
