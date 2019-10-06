/*!
	Adds a negative moodlet.
*/
/datum/disease_property/symptom/headache
	name = "Headache"
	desc = "The disease causes inflammation inside the brain, causing constant headaches."
	symptom_delay_min = 15
	symptom_delay_max = 30
	passive_stage = 4
	var/headache_active = FALSE
	var/strong_headache = FALSE
	var/cluster_headache = FALSE
	var/brain_hemorrhage = FALSE
	threshold_desc = "<b>BETA:</b> Makes headaches more painful.<br>\
					  <b>GAMMA:</b> Rarely causes cluster headaches, which blind and disable the host for a while.<br>\
					  <b>EPSILON:</b> Causes severe brain hemorrhage, eventually leading to death if untreated."

/datum/disease_property/symptom/headache/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		strong_headache = TRUE
	else
		strong_headache = FALSE
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_GAMMA))
		cluster_headache = TRUE
	else
		cluster_headache = FALSE
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_EPSILON))
		brain_hemorrhage = TRUE
	else
		brain_hemorrhage = FALSE

/datum/disease_property/symptom/headache/passive_effect_start()
	if(!headache_active)
		if(!strong_headache)
			SEND_SIGNAL(disease.affected_mob, COMSIG_ADD_MOOD_EVENT, "headache", /datum/mood_event/headache)
		else
			SEND_SIGNAL(disease.affected_mob, COMSIG_ADD_MOOD_EVENT, "headache", /datum/mood_event/headache/strong)
		headache_active = TRUE

/datum/disease_property/symptom/headache/passive_effect_end()
	if(headache_active)
		SEND_SIGNAL(disease.affected_mob, COMSIG_CLEAR_MOOD_EVENT, "headache")
		headache_active = FALSE

/datum/disease_property/symptom/headache/activate()
	var/mob/living/carbon/M = disease.affected_mob
	if(prob(25) && cluster_headache && disease.stage >= 5)
		to_chat(M, "<span class='userdanger'>[pick("You feel a burning knife inside your brain!", "A wave of pain fills your head!")]</span>")
		M.Unconscious(60) //Simulates being in too much pain to focus on anything else
	if(brain_hemorrhage && prob(40))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(10,25))
	if(disease.stage < 4)
		if(message_cooldown())
			to_chat(M, "<span class='warning'>[pick("Your head feels stuffed.", "Your head pounds.")]</span>")
	else
		if(!strong_headache)
			to_chat(M, "<span class='warning'>[pick("Your head hurts.", "Your head pounds painfully.")]</span>")
		else
			to_chat(M, "<span class='warning'>[pick("Your head hurts a lot.", "Your head pounds incessantly.", "You feel needles inside your head.")]</span>")
	
