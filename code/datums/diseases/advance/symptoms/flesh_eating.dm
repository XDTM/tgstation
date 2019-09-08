/*!
	Deals brute damage over time.
*/
/datum/disease_property/symptom/flesh_eating
	name = "Necrotizing Fasciitis"
	desc = "The disease aggressively attacks body cells, necrotizing tissues and organs."
	level = 6
	symptom_delay_min = 3
	symptom_delay_max = 6
	var/pain = FALSE
	threshold_desc = "<b>BETA:</b>Causes stabs of extreme pain to the host, weakening them."

/datum/disease_property/symptom/flesh_eating/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		pain = TRUE
	else
		pain = FALSE

/datum/disease_property/symptom/flesh_eating/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(2,3)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You feel a mild pain across your body.", "Drops of blood appear on your skin.")]</span>")
		if(5)
			flesheat(M)

/datum/disease_property/symptom/flesh_eating/proc/flesheat(mob/living/M)
	var/get_damage = rand(2,4) * multiplier
	M.take_overall_damage(brute = get_damage, required_status = BODYPART_ORGANIC)
	if(pain && prob(7))
		M.adjustStaminaLoss(rand(15, 30))
		M.Immobilize(20)
		to_chat(M, "<span class='userdanger'>[pick("You feel a sudden stab of pain somewhere inside you!", "You feel a terrible cramp through your whole body!", "You feel like you're being eaten from the inside!")]</span>")
	else
		if(message_cooldown())
			to_chat(M, "<span class='warning'>[pick("You feel a constant ache all over your body.", "Your muscles hurt when you move them.")]</span>")
