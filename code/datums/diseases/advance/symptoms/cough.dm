/*!
	Causes the host mob to cough, also spreading the disease if airborne
*/
/datum/disease_property/symptom/cough
	name = "Cough"
	desc = "The virus irritates the throat of the host, causing occasional coughing."
	level = 1
	symptom_delay_min = 2
	symptom_delay_max = 15
	var/drop_items = FALSE
	var/cough_fits = FALSE
	threshold_desc = "<b>ALPHA:</b> Host will drop small items when coughing.<br>\
					  <b>BETA:</b> Increases cough frequency.<br>\
					  <b>GAMMA:</b> Occasionally causes coughing fits that stun the host."

/datum/disease_property/symptom/cough/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_ALPHA])
		drop_items = TRUE
	else
		drop_items = FALSE
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		symptom_delay_max = 10
	else
		symptom_delay_max = initial(symptom_delay_max)
	if(disease.mutators[DISEASE_MUTATOR_GAMMA])
		cough_fits = TRUE
	else
		cough_fits = FALSE

/datum/disease_property/symptom/cough/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You swallow excess mucus.", "You lightly cough.")]</span>")
		else
			M.emote("cough")
			if(drop_items)
				var/obj/item/I = M.get_active_held_item()
				if(I && I.w_class == WEIGHT_CLASS_TINY)
					M.dropItemToGround(I)
			if(cough_fits && prob(10))
				M.visible_message("<span class='warning'>[M] has a coughing fit!</span>", "<span class='userdanger'>[pick("You have a coughing fit!", "You can't stop coughing!")]</span>")
				M.Immobilize(20)
				M.emote("cough")
				addtimer(CALLBACK(M, /mob/.proc/emote, "cough"), 6)
				addtimer(CALLBACK(M, /mob/.proc/emote, "cough"), 12)
				addtimer(CALLBACK(M, /mob/.proc/emote, "cough"), 18)
			if(M.CanSpreadAirborneDisease())
				disease.spread(1)

