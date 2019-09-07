/datum/disease_property/symptom/polyvitiligo
	name = "Polyvitiligo"
	desc = "The virus replaces the melanin in the skin with a reactive pigment that regularly changes color."
	symptom_delay_min = 10
	symptom_delay_max = 20
	var/camo_skin = FALSE
	var/anti_magic = FALSE
	threshold_desc = "<b>GAMMA:</b> The skin pigment becomes mimetic, taking the color of whatever's behind the host.\n
					  <b>THETA:</b> The disease creates an exotic matter layer on top of the host's skin, shielding them from magic influences."

/datum/disease_property/symptom/polyvitiligo/update_mutators()
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_GAMMA))
		camo_skin = TRUE
	else
		camo_skin = FALSE
		next_activation = 0 //refresh skin color
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_THETA))
		anti_magic = TRUE
	else
		anti_magic = FALSE
		if(disease.processing)
			REMOVE_TRAIT(disease.affected_mob, TRAIT_ANTIMAGIC, DISEASE_TRAIT)

/datum/disease_property/symptom/polyvitiligo/on_stage_increase(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 5)
		ADD_TRAIT(M, TRAIT_ANTIMAGIC, DISEASE_TRAIT)

/datum/disease_property/symptom/polyvitiligo/on_stage_decrease(new_stage, prev_stage)
	var/mob/living/carbon/M = disease.affected_mob
	if(new_stage == 4)
		REMOVE_TRAIT(M, TRAIT_ANTIMAGIC, DISEASE_TRAIT)

/datum/disease_property/symptom/polyvitiligo/on_end()
	REMOVE_TRAIT(disease.affected_mob, TRAIT_ANTIMAGIC, DISEASE_TRAIT)

/datum/disease_property/symptom/polyvitiligo/activate()
	var/mob/living/carbon/human/M = disease.affected_mob
	if(!istype(M))
		return
	switch(disease.stage)
		if(5)
			if(camo_skin)
				M.skin_tone = "camo"
				if(message_cooldown())
					to_chat(M, "<span class='notice'>Your skin tingles...</span>")
				M.update_body_parts()
				return
			M.skin_tone = pick("orange","green","red","blue","cyan","yellow","pink")
			to_chat(M, "<span class='notice'>You feel a tingling sensation pass over all your skin.</span>")
			M.update_body_parts()
		else
			if(message_cooldown())
				to_chat(M, "<span class='notice'>Your skin tingles...</span>")

/datum/disease_property/symptom/polyvitiligo/on_end()
	var/mob/living/carbon/human/M = disease.affected_mob
	if(!istype(M))
		return
	//Return skin tone to normal
	M.skin_tone = GLOB.skin_tones[deconstruct_block(getblock(M.dna.uni_identity, DNA_SKIN_TONE_BLOCK), GLOB.skin_tones.len)]
	M.update_body_parts()
