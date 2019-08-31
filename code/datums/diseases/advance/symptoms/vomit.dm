/datum/disease_property/symptom/vomit
	name = "Vomiting"
	desc = "The disease causes nausea and irritates the stomach, causing occasional vomiting."
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/food_vomit = FALSE
	var/vomit_distance = 1
	threshold_desc = "<b>ALPHA:</b> Makes the vomiting reflex more severe, causing projectile vomiting.<br>\
					  <b>BETA:</b> Triggers the vomit reflex whenever the host's well fed."

/datum/disease_property/symptom/vomit/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_ALPHA))
		vomit_distance = 4
	else
		vomit_distance = 1
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_BETA))
		food_vomit = TRUE
	else
		food_vomit = FALSE

/datum/disease_property/symptom/vomit/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You feel nauseous.", "You feel like you're going to throw up!")]</span>")
		else
			vomit(M)

/datum/disease_property/symptom/vomit/on_process()
	..()
	if(food_vomit && (disease.stage >= 5) && (disease.affected_mob.nutrition > NUTRITION_LEVEL_WELL_FED))
		next_activation = 0 //Trigger vomit next tick

/datum/disease_property/symptom/vomit/proc/vomit(mob/living/carbon/M)
	M.vomit(20, FALSE, distance = vomit_distance)
