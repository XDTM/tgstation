GLOBAL_LIST_INIT(injuries, typesof(/datum/injury))

/datum/injury
	var/name = "Injury"
	var/desc = "An injury which causes issues to the patient."
	var/examine_desc = "a generic injury" //description when examined
	var/mob/living/carbon/owner	//The bodypart's owner
	var/obj/item/bodypart/bodypart //The injured bodypart
	var/can_gain = FALSE //can this be gained through random traumas?
	
	var/severity = 0 //how debilitating/dangerous it is
	var/max_amount = 1 //how many can you have in the same limb? (i.e. cuts vs broken bone)
	
	var/bodypart_status = BODYPART_ORGANIC	//separates organic and robotic injuries
	var/list/possible_bodyparts = list(/obj/item/bodypart) //can only be applied to these bodypart types
	var/list/required_organs = list()
	var/list/injury_tags = list()	//tags used to choose random injuries (i.e. blunt damage won't cause deep cuts)
								//the injury needs to have at least one tag in common with the injury source
	
/datum/injury/arms
	possible_bodyparts = list(/obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm)
	
/datum/injury/legs
	possible_bodyparts = list(/obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	
/datum/injury/limbs
	possible_bodyparts = list(/obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	
/datum/injury/chest
	possible_bodyparts = list(/obj/item/bodypart/chest)
	
/datum/injury/head
	possible_bodyparts = list(/obj/item/bodypart/head)
	
/datum/injury/New(obj/item/bodypart/target)
	if(!check_valid(target))
		qdel(src)
		return
	//TODO check for required organs
	bodypart = target
	bodypart.injuries += src
	on_add()
	if(source_bodypart.owner)
		owner = bodypart.owner
		on_gain()
	
/datum/injury/Destroy()
	bodypart.injuries -= src
	on_remove()
	if(owner)
		on_lose()
	bodypart = null
	owner = null
	return ..()

/datum/injury/proc/check_valid(obj/item/bodypart/target_bodypart)
	var/dupe_amount = 0
	for(var/X in target_bodypart.injuries)
		if(istype(X, src))
			dupe_amount++
			if(dupe_amount >= max_amount)
				return FALSE
	
	for(var/X in required_organs)
		if(target_bodypart.owner)
			if(!(locate(X) in owner.internal_organs))
				return FALSE
		else
			if(!(locate(X) in target_bodypart.contents))
				return FALSE
	
	for(var/X in possible_bodyparts)
		if(istype(target_bodypart, X))
			return TRUE
	return FALSE
	
//Called on life ticks
/datum/injury/proc/on_life()
	return

//Called when given to a bodypart
/datum/injury/proc/on_add()
	return
	
//Called when removed from a bodypart
/datum/injury/proc/on_remove()
	return		
	
//Called when given to a mob
/datum/injury/proc/on_gain()
	gain_message()
	
/datum/injury/proc/gain_message()
	to_chat(owner, "<span class='notice'>You feel a sudden, oddly generic pain.</span>")

//Called when removed from a mob
/datum/injury/proc/on_lose(silent)
	if(!silent)
		lose_message()
		
/datum/injury/proc/lose_message()
	to_chat(owner, "<span class='notice'>You no longer feel generically hurt.</span>")
	
//Called when the limb is damaged
/datum/injury/proc/on_damage(brute, burn)
	return
	