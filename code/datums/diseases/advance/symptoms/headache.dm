/*!
	Adds a negative moodlet.
*/
/datum/disease_property/symptom/headache
	name = "Headache"
	desc = "The virus causes inflammation inside the brain, causing constant headaches."
	level = 1
	symptom_delay_min = 15
	symptom_delay_max = 30
	var/headache_active = FALSE
	var/strong_headache = FALSE
	var/cluster_headache = FALSE
	threshold_desc = "<b>BETA:</b> Makes headaches more painful.<br>\
					  <b>GAMMA:</b> Rarely causes cluster headaches, which blind and disable the host for a while."

/datum/disease_property/symptom/headache/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		strong_headache = TRUE
	else
		strong_headache = FALSE
	if(disease.mutators[DISEASE_MUTATOR_GAMMA])
		cluster_headache = TRUE
	else
		cluster_headache = FALSE

/datum/disease_property/symptom/headache/on_stage_change(new_stage, prev_stage)
	if(new_stage > prev_stage)
		if(new_stage >= 4 && !headache_active)
			if(!strong_headache)
				SEND_SIGNAL(disease.affected_mob, COMSIG_ADD_MOOD_EVENT, "headache", /datum/mood_event/headache)
			else
				SEND_SIGNAL(disease.affected_mob, COMSIG_ADD_MOOD_EVENT, "headache", /datum/mood_event/headache/strong)
			headache_active = TRUE
	else
		if(new_stage <= 3 && headache_active)
			SEND_SIGNAL(disease.affected_mob, COMSIG_CLEAR_MOOD_EVENT, "headache")
			headache_active = FALSE

/datum/disease_property/symptom/headache/on_end()
	SEND_SIGNAL(disease.affected_mob, COMSIG_CLEAR_MOOD_EVENT, "headache")
	headache_active = FALSE

/datum/disease_property/symptom/headache/activate()
	var/mob/living/M = disease.affected_mob
	if(prob(25) && cluster_headache && disease.stage >= 5)
		to_chat(M, "<span class='userdanger'>[pick("You feel a burning knife inside your brain!", "A wave of pain fills your head!")]</span>")
		M.Unconscious(60) //Simulates being in too much pain to focus on anything else
	if(disease.stage < 4)
		if(message_cooldown())
			to_chat(M, "<span class='warning'>[pick("Your head aches.", "Your head pounds.")]</span>")
	else
		if(!strong_headache)
			to_chat(M, "<span class='warning'>[pick("Your head hurts.", "Your head pounds painfully.")]</span>")
		else
			to_chat(M, "<span class='warning'>[pick("Your head hurts a lot.", "Your head pounds incessantly.", "You feel needles inside your head.")]</span>")
	
