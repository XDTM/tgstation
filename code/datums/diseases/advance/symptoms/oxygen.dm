
/datum/disease_property/symptom/oxygen
	name = "Self-Respiration"
	desc = "The virus rapidly synthesizes oxygen, effectively removing the need for breathing."
	var/regenerate_blood = FALSE
	threshold_desc = "<b>Resistance 8:</b>Additionally regenerates lost blood.<br>"

/datum/disease_property/symptom/oxygen/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 8) //blood regeneration
		regenerate_blood = TRUE

/datum/disease_property/symptom/oxygen/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			M.adjustOxyLoss(-7, 0)
			M.losebreath = max(0, M.losebreath - 4)
			if(regenerate_blood && M.blood_volume < BLOOD_VOLUME_NORMAL)
				M.blood_volume += 1
		else
			if(prob(base_message_chance))
				to_chat(M, "<span class='notice'>[pick("Your lungs feel great.", "You realize you haven't been breathing.", "You don't feel the need to breathe.")]</span>")
	return

/datum/disease_property/symptom/oxygen/on_stage_change(new_stage, datum/disease/advance/A)
	if(!..())
		return FALSE
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(3)
			REMOVE_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)
		if(4)
			ADD_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)
	return TRUE

/datum/disease_property/symptom/oxygen/End(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage >= 4)
		REMOVE_TRAIT(A.affected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
