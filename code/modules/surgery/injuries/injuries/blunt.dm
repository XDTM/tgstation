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
	max_amount = 1
	severity = INJURY_SEVERITY_NORMAL
	injury_tags = list(INJURY_TAG_BLUNT)
	
//TODO make this not conflict with damage	
/datum/injury/limb/bone/on_add()
	bodypart.disabled = TRUE
	
/datum/injury/limb/bone/on_remove()
	bodypart.disabled = FALSE
	
/datum/injury/chest/ribs
	name = "Broken Ribs"
	desc = "Broken ribs, causing occasional acute pain when breathing."
	examine_desc = "broken ribs"
	can_gain = TRUE
	max_amount = 1
	severity = INJURY_SEVERITY_SEVERE
	injury_tags = list(INJURY_TAG_BLUNT)

/datum/injury/chest/ribs/on_life()
	if(prob(2))
		pain_fit()
	
/datum/injury/chest/ribs/on_damage(brute, burn)
	if(prob(brute * 3))
		pain_fit()
	
/datum/injury/chest/ribs/proc/pain_fit()
	to_chat(owner, "<span class='userdanger'>You feel a stabbing pain in your [bodypart.name]!</span>")
	owner.emote("scream") //grimace maybe?
	owner.adjustStaminaLoss(60)