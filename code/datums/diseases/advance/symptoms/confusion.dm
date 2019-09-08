/*!
	Makes the affected mob confused and dizzy for short periods of time.
*/
/datum/disease_property/symptom/confusion
	name = "Auricolar Burst"
	desc = "The disease causes occasional bursts of air in the ear's labyrinth, causing dizziness and lack of balance."
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/stumble = FALSE
	threshold_desc = "<b>ALPHA:</b> Increases duration.<br>\
					  <b>BETA:</b> Causes more severe loss of balance, leading to stumbling and falling."

/datum/disease_property/symptom/confusion/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_ALPHA))
		multiplier = 1.5
	else
		multiplier = 1
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		stumble = TRUE
	else
		stumble = FALSE

/datum/disease_property/symptom/confusion/on_process()
	..()
	if(!stumble)
		return
	var/mob/living/carbon/M = disease.affected_mob
	if(M.confused && (M.mobility_flags & MOBILITY_MOVE) && prob(M.confused))
		to_chat(M, "<span class='warning'>[pick("You trip on your own feet!","You lose your balance!","You trip and fall!","You lose your balance in your confusion!")]</span>")
		step(M, M.dir)
		M.Knockdown(20)

/datum/disease_property/symptom/confusion/activate()
	var/mob/living/carbon/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("Your head hurts.", "Your mind blanks for a moment.", "You feel dizzy.")]</span>")
		else
			to_chat(M, "<span class='warning'>[pick("You feel a pop in your ear, and a wave of dizziness hits you!")]</span>")
			M.confused = min(M.confused + (10 * multiplier), 100)
			M.dizziness = min(M.dizziness + (10 * multiplier), 100)
