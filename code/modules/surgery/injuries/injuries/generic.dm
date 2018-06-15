/datum/injury/scratch
	name = "Scratch"
	desc = "It kinda itches. Ironic."
	examine_desc = "a scratch"
	can_gain = TRUE
	max_amount = 2
	severity = INJURY_SEVERITY_MINOR
	injury_tags = list(INJURY_TAG_SHARP, INJURY_TAG_BLUNT)
	
/datum/injury/scratch/on_life()
	if(prob(4))
		to_chat(owner, "<span class='warning'>Your scratched [bodypart.name] itches.</span>")
		

	
