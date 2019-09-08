/datum/disease_property/symptom/shedding
	name = "Alopecia"
	desc = "The disease causes rapid shedding of head and body hair."
	symptom_delay_min = 45
	symptom_delay_max = 90

	//TODO shedding limbs on Delta or Epsilon

/datum/disease_property/symptom/shedding/activate()
	var/mob/living/M = disease.affected_mob
	if(message_cooldown())
		to_chat(M, "<span class='warning'>[pick("Your scalp itches.", "Your skin feels flaky.")]</span>")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(disease.stage)
			if(3, 4)
				if(!(H.hair_style == "Bald") && !(H.hair_style == "Balding Hair"))
					to_chat(H, "<span class='warning'>Your hair starts to fall out in clumps...</span>")
					addtimer(CALLBACK(src, .proc/shed, H, FALSE), 50)
			if(5)
				if(!(H.facial_hair_style == "Shaved") || !(H.hair_style == "Bald"))
					to_chat(H, "<span class='warning'>Your hair starts to fall out in clumps...</span>")
					addtimer(CALLBACK(src, .proc/shed, H, TRUE), 50)

/datum/disease_property/symptom/shedding/proc/shed(mob/living/carbon/human/H, fullbald)
	if(fullbald)
		H.facial_hair_style = "Shaved"
		H.hair_style = "Bald"
	else
		H.hair_style = "Balding Hair"
	H.update_hair()
