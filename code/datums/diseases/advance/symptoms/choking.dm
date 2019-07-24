/*!
	Inflicts spikes of oxyloss
*/

/datum/disease_property/symptom/choking
	name = "Choking"
	desc = "The virus causes inflammation of the host's air conduits, leading to intermittent choking."
	level = 3
	base_message_chance = 15
	symptom_delay_min = 30
	symptom_delay_max = 120
	threshold_desc = "<b>GAMMA:</b> Doubles the duration of choking episodes."

/datum/disease_property/symptom/choking/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_GAMMA))
		multiplier = 2
	else
		multiplier = 1

/datum/disease_property/symptom/choking/activate()
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]</span>")
		if(3, 4)
			to_chat(M, "<span class='warning'>[pick("Your windpipe feels like a straw.", "Your breathing becomes tremendously difficult.")]</span>")
			choke(M, 4)
			M.emote("gasp")
		else
			to_chat(M, "<span class='userdanger'>[pick("You're choking!", "You can't breathe!")]</span>")
			choke(M, 8)
			M.emote("gasp")

/datum/disease_property/symptom/choking/proc/choke(mob/living/M, amount)
	M.losebreath = CLAMP(M.losebreath + (amount * multiplier), 0, 10)
