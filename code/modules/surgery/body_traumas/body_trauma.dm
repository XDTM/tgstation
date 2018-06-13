/datum/body_trauma
	var/name = "Body Trauma"
	var/desc = "A trauma which causes issues to the patient."
	var/scan_desc = "a generic body trauma" //description when detected by a health scanner
	var/mob/living/carbon/owner	//The bodypart's owner
	var/obj/item/bodypart/source_bodypart //The bodypart that has the trauma
	var/gain_text = "<span class='notice'>You feel generically traumatized.</span>"
	var/lose_text = "<span class='notice'>You no longer feel generically traumatized.</span>"
	var/can_gain = TRUE //can this be gained through random traumas?
	
	var/possible_bodyparts = list(/obj/item/bodypart) //can only be applied to these bodypart types
	var/damage_tags = list()	//type of the damage source, used to determine the trauma type
	
/datum/body_trauma/arms
	possible_bodyparts = list(/obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm)
	
/datum/body_trauma/legs
	possible_bodyparts = list(/obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	
/datum/body_trauma/limbs
	possible_bodyparts = list(/obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	
/datum/body_trauma/chest
	possible_bodyparts = list(/obj/item/bodypart/chest)
	
/datum/body_trauma/head
	possible_bodyparts = list(/obj/item/bodypart/head)
	
/datum/body_trauma/New(obj/item/bodypart/target)
	if(check_valid_bodypart(target))
		qdel(src)
		return
	source_bodypart = target
	source_bodypart.body_traumas += src
	on_add()
	if(source_bodypart.owner)
		owner = source_bodypart.owner
		on_gain()
	
/datum/body_trauma/Destroy()
	source_bodypart.body_traumas -= src
	on_remove()
	if(owner)
		on_lose()
	source_bodypart = null
	owner = null
	return ..()

/datum/body_trauma/proc/check_valid_bodypart(obj/item/bodypart/bodypart)
	for(var/X in possible_bodyparts)
		if(istype(bodypart, X))
			return TRUE
	return FALSE
	
//Called on life ticks
/datum/body_trauma/proc/on_life()
	return

//Called when given to a bodypart
/datum/body_trauma/proc/on_add()
	return
	
//Called when removed from a bodypart
/datum/body_trauma/proc/on_remove()
	return		
	
//Called when given to a mob
/datum/body_trauma/proc/on_gain()
	to_chat(owner, gain_text)

//Called when removed from a mob
/datum/body_trauma/proc/on_lose(silent)
	if(!silent)
		to_chat(owner, lose_text)