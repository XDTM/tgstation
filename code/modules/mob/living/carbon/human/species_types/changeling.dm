/datum/species/changeling
	name = "Changeling"
	id = "changeling"
	blacklisted = TRUE
	liked_food = MEAT | RAW
	skinned_type = /obj/effect/decal/cleanable/blood/gibs
	inherent_traits = list(TRAIT_LIMBATTACHMENT, TRAIT_NODEATH)
	
	var/datum/species/disguise //The species we're currently disguised as
	var/biomode = BIOMODE_DISGUISE	//Determines how the body reacts to damage; in Survival mode changelings can shrug off a lot more than Disguise mode,
									//but because of this they'll be easier to tell apart from normal people
	
/datum/species/changeling/proc/can_imitate(mob/living/carbon/human/H, datum/species/species)
	if(species.blacklisted)
		return FALSE
	if(NOTRANSSTING in species.species_traits)
		return FALSE
	if(!(MOB_ORGANIC in species.inherent_biotypes))
		return FALSE
	return TRUE
	
/datum/species/changeling/proc/set_form(mob/living/carbon/human/H, species_type)
	on_species_loss(H)
	
	QDEL_NULL(disguise)
	disguise = new species_type
	
	name = disguise.name
	limbs_id = disguise.id
	mutanttongue = disguise.mutanttongue
	mutanttail = disguise.mutanttail
	damage_overlay_type = disguise.damage_overlay_type
	attack_verb = disguise.attack_verb
	attack_sound = disguise.attack_sound
	miss_sound = disguise.miss_sound
	ignored_by = disguise.ignored_by
	say_mod = disguise.say_mod
	default_color = disguise.default_color
	species_traits = disguise.species_traits
	sexes = disguise.sexes
	use_skintones = disguise.use_skintones
	default_features = disguise.default_features
	
	on_species_gain(H, src)
	
/datum/species/changeling/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	if((istype(old_species, /datum/species/changeling))
		if(!disguise)
			set_form(/datum/species/human)		
	else
		set_form(old_species.type)
	..()
	
/datum/species/changeling/regenerate_organs(mob/living/carbon/C,datum/species/old_species,replace_current=TRUE)
	disguise.regenerate_organs(C,old_species,replace_current) //get the organs from the disguised species
	..(C,old_species,FALSE) //fill in any missing organs
	
/datum/species/changeling/handle_hair(mob/living/carbon/human/H, forced_colour)	
	disguise.handle_hair(H,forced_colour)
	
/datum/species/changeling/handle_body(mob/living/carbon/human/H)	
	disguise.handle_body(H)
	
/datum/species/changeling/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	disguise.handle_body(H, forced_colour)
	
/datum/species/changeling/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	return disguise.can_equip(I,slot,disable_warning,H,bypass_equip_delay_self)
	
/datum/species/changeling/handle_speech(message, mob/living/carbon/human/H)
	return disguise.handle_speech(message, H)
	
/datum/species/changeling/get_spans()
	return disguise.get_spans()
	
/datum/species/changeling/switch_biomode(mob/living/carbon/human/H, new_biomode)
	switch(new_biomode)
		if(BIOMODE_DISGUISE)
			H.remove_trait(TRAIT_NOBREATH, "changeling")
			H.remove_trait(TRAIT_NOHARDCRIT, "changeling")
		if(BIOMODE_SURVIVAL)
			H.add_trait(TRAIT_NOBREATH, "changeling") //We don't need oxygen anymore
			H.add_trait(TRAIT_NOHARDCRIT, "changeling")
			H.cure_fakedeath("changeling") //We don't need death anymore

/datum/species/changeling/spec_life(mob/living/carbon/human/H)
	if(biomode == BIOMODE_SURVIVAL) //Cells regenerate over time, we no longer need to simulate wounds
		H.heal_overall_damage(1,1)
		H.adjustToxLoss(-1)
	if(biomode == BIOMODE_DISGUISE)
		if(H.health <= H.maxHealth && !H.has_trait(TRAIT_FAKEDEATH)) //Pretend we died
			H.emote("deathgasp")
			H.fakedeath("changeling")
