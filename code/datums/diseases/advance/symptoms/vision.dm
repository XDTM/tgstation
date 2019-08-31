///When the host's eyes are damaged or missing, gradually restores them.
/datum/disease_property/symptom/ocular_regrowth
	name = "Ocular Regrowth"
	desc = "The disease stimulates the production and replacement of sensory tissues, causing the host to regenerate their eyes if damaged."
	var/regrowth_progress = 0
	var/thermal_vision = FALSE
	var/flash_proof = FALSE
	threshold_desc = "<b>BETA:</b> The disease prevents bright lights from damaging the retina.<br>\
					  <b>DELTA:</b> The disease forms a heat-sensitive membrane in front of the retina, granting thermal vision to the host."

/datum/disease_property/symptom/ocular_regrowth/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_BETA))
		flash_proof = TRUE
	else
		flash_proof = FALSE
		REMOVE_TRAIT(disease.affected_mob, TRAIT_FLASH_PROOF, OCULAR_REGROWTH_TRAIT)
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_DELTA))
		thermal_vision = TRUE
	else
		thermal_vision = FALSE
		REMOVE_TRAIT(disease.affected_mob, TRAIT_THERMAL_VISION, OCULAR_REGROWTH_TRAIT)

/datum/disease_property/symptom/ocular_regrowth/on_stage_increase(new_stage, prev_stage)
	if(new_stage == 5)
		if(thermal_vision)
			ADD_TRAIT(disease.affected_mob, TRAIT_THERMAL_VISION, OCULAR_REGROWTH_TRAIT)
		if(flash_proof)
			ADD_TRAIT(disease.affected_mob, TRAIT_FLASH_PROOF, OCULAR_REGROWTH_TRAIT)

/datum/disease_property/symptom/ocular_regrowth/on_stage_decrease(new_stage, prev_stage)
	if(new_stage == 4)
		if(thermal_vision)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_THERMAL_VISION, OCULAR_REGROWTH_TRAIT)
		if(flash_proof)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_FLASH_PROOF, OCULAR_REGROWTH_TRAIT)

/datum/disease_property/symptom/ocular_regrowth/on_end(new_stage, prev_stage)
	REMOVE_TRAIT(disease.affected_mob, TRAIT_THERMAL_VISION, OCULAR_REGROWTH_TRAIT)
	REMOVE_TRAIT(disease.affected_mob, TRAIT_FLASH_PROOF, OCULAR_REGROWTH_TRAIT)

/datum/disease_property/symptom/ocular_regrowth/on_process()
	..()
	var/mob/living/carbon/C = disease.affected_mob
	var/obj/item/organ/eyes/eyes = C.getorganslot(ORGAN_SLOT_EYES)
	switch(disease.stage)
		if(4, 5)
			regrowth_progress += 4
			if(!eyes)
				if(regrowth_progress >= 100)
					var/obj/item/organ/eyes/new_eyes = new
					new_eyes.Insert(C)
					to_chat(C, "<span class='notice'>You feel a pressure behind your eye sockets... then you realize that you have a new pair of eyes!</span>")
					regrowth_progress = 0
				return
			if(HAS_TRAIT_FROM(C, TRAIT_BLIND, EYE_DAMAGE))
				if(regrowth_progress >= 75)
					to_chat(C, "<span class='notice'>Your vision slowly returns...</span>")
					C.cure_blind(EYE_DAMAGE)
					C.cure_nearsighted(EYE_DAMAGE)
					C.blur_eyes(35)
					regrowth_progress = 0
			else if(HAS_TRAIT_FROM(C, TRAIT_NEARSIGHT, EYE_DAMAGE))
				if(regrowth_progress >= 40)
					to_chat(C, "<span class='notice'>You can finally focus your eyes on distant objects.</span>")
					C.cure_nearsighted(EYE_DAMAGE)
					C.blur_eyes(10)
					regrowth_progress = 0
			else if(C.eye_blind || C.eye_blurry)
				if(regrowth_progress >= 20)
					C.set_blindness(0)
					C.set_blurriness(0)
					regrowth_progress = 0
			else if(eyes.damage > 0)
				if(regrowth_progress >= 8)
					eyes.applyOrganDamage(-2)
					regrowth_progress = 0
			else
				regrowth_progress = 0 //Won't store regrowth for the next damage
		else
			if(message_cooldown())
				to_chat(C, "<span class='notice'>[pick("Your eyes feel great.","You feel like your eyes can focus more clearly.", "You don't feel the need to blink.")]</span>")

///Causes gradual eye damage
/datum/disease_property/symptom/visionloss
	name = "Hyphema"
	desc = "The virus causes inflammation of the retina, leading to eye damage and eventually blindness."
	symptom_delay_min = 40
	symptom_delay_max = 80
	var/remove_eyes = FALSE
	threshold_desc = "<b>DELTA:</b> Weakens extraocular muscles, eventually leading to complete detachment of the eyes."

/datum/disease_property/symptom/visionloss/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_DELTA))
		remove_eyes = TRUE
	else
		remove_eyes = FALSE

/datum/disease_property/symptom/visionloss/activate()
	var/mob/living/carbon/M = disease.affected_mob
	var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		switch(disease.stage)
			if(1, 2)
				if(message_cooldown())
					to_chat(M, "<span class='warning'>Your eyes itch.</span>")
			if(3, 4)
				to_chat(M, "<span class='warning'><b>Your eyes burn!</b></span>")
				M.blur_eyes(10)
				eyes.applyOrganDamage(3)
			else
				M.blur_eyes(20)
				eyes.applyOrganDamage(rand(8, 13))
				if(!remove_eyes)
					to_chat(M, "<span class='userdanger'>Your eyes burn horrifically!</span>")
				else if(eyes.organ_flags & ORGAN_FAILING)
					M.visible_message("<span class='warning'>[M]'s eyes fall out of their sockets!</span>", "<span class='userdanger'>Your eyes fall out of their sockets!</span>")
					M.emote("scream")
					eyes.Remove(M)
					eyes.forceMove(get_turf(M))
