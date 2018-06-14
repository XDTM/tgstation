/datum/injury/scratch
	name = "Scratch"
	desc = "It kinda itches."
	examine_desc = "a scratch"
	can_gain = TRUE
	max_amount = 2
	severity = INJURY_SEVERITY_MINOR
	injury_tags = list(INJURY_TAG_SHARP, INJURY_TAG_BLUNT)
	
/datum/injury/scratch/on_life()
	if(prob(4))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s scratch itches.</span>")

/datum/injury/cut
	name = "Generic Cut"
	desc = "An injury which causes bleeding."
	examine_desc = "a cut"
	can_gain = FALSE

	max_amount = 2
	
	bodypart_status = BODYPART_ORGANIC
	possible_bodyparts = list(/obj/item/bodypart)
	injury_tags = list(INJURY_TAG_SHARP)
	
	var/bleed_rate = 0
	
/datum/injury/cut/on_life()
	owner.bleed(bleed_rate)
	if(prob(3))
		to_chat(owner, "<span class='warning'>Your [bodypart.name] feels wet...</span>")
		
/datum/injury/cut/tiny
	name = "Tiny Cut"
	desc = "A cut that looks more serious than it is."
	examine_desc = "a tiny cut"
	can_gain = TRUE
	max_amount = 8
	severity = INJURY_SEVERITY_MINOR
	bleed_rate = 0.15
	
/datum/injury/cut/normal
	name = "Cut"
	desc = "A cut that causes bleeding."
	examine_desc = "a cut"
	can_gain = TRUE
	max_amount = 4
	severity = INJURY_SEVERITY_NORMAL
	bleed_rate = 0.75
	
/datum/injury/cut/artery
	name = "Arterial Cut"
	desc = "A cut that hit an artery, causing rapid bleeding."
	examine_desc = "a deep cut"
	can_gain = TRUE
	max_amount = 1
	severity = INJURY_SEVERITY_SEVERE
	bleed_rate = 2.5	
	
/datum/injury/cut/deep
	name = "Deep Cut"
	desc = "A cut that's hard to heal."
	examine_desc = "a deep cut"
	can_gain = TRUE
	max_amount = 2
	severity = INJURY_SEVERITY_SEVERE
	bleed_rate = 0.75
	
/datum/injury/bruise
	name = "Bruise"
	desc = "A mild hematoma caused by a hard impact."
	examine_desc = "a bruise"
	can_gain = TRUE
	max_amount = 3
	severity = INJURY_SEVERITY_MINOR
	injury_tags = list(INJURY_TAG_BLUNT)
	
/datum/injury/bruise/on_life()
	if(prob(4))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s bruise hurts.</span>")
		
/datum/injury/limb/bone
	name = "Broken Bone"
	desc = "The bone is broken."
	examine_desc = "a broken bone"
	can_gain = TRUE
	max_amount = 3
	severity = INJURY_SEVERITY_NORMAL
	injury_tags = list(INJURY_TAG_BLUNT)
	
//TODO make this not conflict with damage	
/datum/injury/limb/bone/on_add()
	bodypart.disabled = TRUE
	
/datum/injury/limb/bone/on_remove()
	bodypart.disabled = FALSE
	
/datum/injury/chest/ribs
	name = "Broken Bone"
	desc = "The bone is broken."
	examine_desc = "a broken bone"
	can_gain = TRUE
	max_amount = 3
	severity = INJURY_SEVERITY_NORMAL
	injury_tags = list(INJURY_TAG_BLUNT)

/datum/injury/limb/ribs/on_life()
	//TODO random pain attacks
	
//TODO on_damage event
	