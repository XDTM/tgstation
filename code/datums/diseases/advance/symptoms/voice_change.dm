/datum/disease_property/symptom/voice_change
	name = "Voice Change"
	desc = "The virus alters the pitch and tone of the host's vocal cords, changing how their voice sounds."
	symptom_delay_min = 90
	symptom_delay_max = 150
	threshold_desc = "<b>ALPHA:</b> The disease keeps changing the host's voice, instead of only changing it once.<br>\
					  <b>GAMMA:</b> Paralyzes the host's vocal cords, forcing them to only whisper."
	var/repeat = FALSE
	var/whisper = FALSE

/datum/disease_property/symptom/voice_change/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_ALPHA))
		repeat = TRUE
	else
		repeat = FALSE
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_GAMMA))
		whisper = TRUE
	else
		whisper = FALSE
		if(disease.processing)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_FORCEWHISPER, VOICE_CHANGE_TRAIT)

/datum/disease_property/symptom/voice_change/on_end()
	restore_voice()

/datum/disease_property/symptom/voice_change/activate()
	var/mob/living/carbon/M = disease.affected_mob
	if(disease.stage < 5)
		if(message_cooldown())
			to_chat(M, "<span class='warning'>[pick("Your throat itches.", "You clear your throat.")]</span>")
	else if(repeat)
		randomize_voice()

/datum/disease_property/symptom/voice_change/on_stage_increase(new_stage, prev_stage)
	if(new_stage == 5)
		randomize_voice()
		if(whisper)
			var/mob/living/carbon/M = disease.affected_mob
			ADD_TRAIT(M, TRAIT_FORCEWHISPER, VOICE_CHANGE_TRAIT)

/datum/disease_property/symptom/voice_change/on_stage_decrease(new_stage, prev_stage)
	if(new_stage == 4)
		restore_voice()

/datum/disease_property/symptom/voice_change/proc/randomize_voice()	
	var/mob/living/carbon/M = disease.affected_mob
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.SetSpecialVoice(H.dna.species.random_name(H.gender))

/datum/disease_property/symptom/voice_change/proc/restore_voice()	
	var/mob/living/carbon/M = disease.affected_mob
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.UnsetSpecialVoice()
	REMOVE_TRAIT(M, TRAIT_FORCEWHISPER, VOICE_CHANGE_TRAIT)
