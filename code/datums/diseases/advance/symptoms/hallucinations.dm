/*!
	Causes occasional hallucinations.
*/

/datum/disease_property/symptom/hallucinations
	name = "Hallucinations"
	desc = "The virus stimulates the brain, causing occasional hallucinations."
	level = 5
	symptom_delay_min = 25
	symptom_delay_max = 90
	var/hypnosis = FALSE
	threshold_desc = "<b>ALPHA:</b> Increases the duration of hallucinations.<br>\
					  <b>DELTA:</b> Rarely causes hypnotic trances on the host."

/datum/disease_property/symptom/hallucinations/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_ALPHA))
		multiplier = 2
	else
		multiplier = 1
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_DELTA))
		hypnosis = TRUE
	else
		hypnosis = FALSE

/datum/disease_property/symptom/hallucinations/activate()
	var/mob/living/carbon/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2)
			if(message_cooldown())
				to_chat(M, "<span class='notice'>[pick("Something appears in your peripheral vision, then winks out.", "You hear a faint whisper with no source.", "Your head aches.")]</span>")
		if(3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='danger'>[pick("Something is following you.", "You are being watched.", "You hear a whisper in your ear.", "Thumping footsteps slam toward you from nowhere.")]</span>")
		else
			if(hypnosis && prob(15))
				M.apply_status_effect(/datum/status_effect/trance, rand(100,200), FALSE)
			else
				if(message_cooldown())
					to_chat(M, "<span class='userdanger'>[pick("Oh, your head...", "Your head pounds rhytmically.", "They're watching.", "Something in the shadows... wriggling...", "Thumping footsteps slam toward you from nowhere.")]</span>")
				M.hallucination += (20 * multiplier)
