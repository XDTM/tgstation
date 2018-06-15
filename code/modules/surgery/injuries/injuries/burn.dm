/datum/injury/burn
	name = "N-degree Burn"
	desc = "A burn of an indefinite degree. How odd."
	examine_desc = "a burn"
	can_gain = FALSE

	max_amount = 1
	
	bodypart_status = BODYPART_ORGANIC
	possible_bodyparts = list(/obj/item/bodypart)
	injury_tags = list(INJURY_TAG_BURN)
	
/datum/injury/burn/first
	name = "First degree burn"
	desc = "A patch of reddened skin. Hurts, but is not dangerous."
	examine_desc = "a superficial burn"
	can_gain = TRUE
	max_amount = 2
	severity = INJURY_SEVERITY_MINOR
	
/datum/injury/burn/first/on_life()
	if(prob(4))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s burn hurts.</span>")
		owner.adjustStaminaLoss(5)

/datum/injury/burn/first/on_damage(brute, burn)
	if(prob(40))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s burn hurts!</span>")
			owner.adjustStaminaLoss(5)		
		
/datum/injury/burn/second
	name = "Second degree burn"
	desc = "A patch of red, swollen and blistered skin."
	examine_desc = "a second-degree burn"
	can_gain = TRUE
	max_amount = 1
	severity = INJURY_SEVERITY_MEDIUM
	
/datum/injury/burn/second/on_life()
	if(prob(7))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s burn hurts.</span>")
		owner.adjustStaminaLoss(10)
		
/datum/injury/burn/second/on_damage(brute, burn)
	if(prob(75))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s burn hurts!</span>")
			owner.adjustStaminaLoss(10)
	
	
/datum/injury/burn/third
	name = "Third degree burn"
	desc = "A large patch of black, charred skin."
	examine_desc = "a third-degree burn"
	can_gain = TRUE
	max_amount = 1
	severity = INJURY_SEVERITY_SEVERE
	
/datum/injury/burn/third/on_gain()
	..()
	bodypart.disabled = TRUE
		
/datum/injury/burn/third/on_damage(brute, burn)
	if(prob(75))
		to_chat(owner, "<span class='warning'>Your [bodypart.name]'s burn hurts!</span>")
			owner.adjustStaminaLoss(10)	