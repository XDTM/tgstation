/*!
	Causes intermittent loss of hearing.
*/
/datum/disease_property/symptom/deafness
	name = "Deafness"
	desc = "The virus causes inflammation of the eardrums, causing intermittent deafness."
	level = 4
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/permanent = FALSE
	threshold_desc = "<b>DELTA:</b> Causes permanent deafness, instead of intermittent."

/datum/disease_property/symptom/deafness/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_DELTA])
		permanent = TRUE
	else
		permanent = FALSE

/datum/disease_property/symptom/deafness/activate()
	var/mob/living/carbon/M = disease.affected_mob
	switch(disease.stage)
		if(3, 4)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You hear a ringing in your ear.", "Your ears pop.")]</span>")
		if(5)
			if(permanent)
				var/obj/item/organ/ears/ears = M.getorganslot(ORGAN_SLOT_EARS)
				if(istype(ears) && ears.damage < ears.maxHealth)
					to_chat(M, "<span class='userdanger'>Your ears pop painfully and start bleeding!</span>")
					ears.damage = max(ears.damage, ears.maxHealth)
					M.emote("scream")
			else
				to_chat(M, "<span class='userdanger'>Your ears pop and begin ringing loudly!</span>")
				M.minimumDeafTicks(20)
