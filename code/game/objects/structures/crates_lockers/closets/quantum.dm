/obj/structure/closet/quantum
	name = "quantum-entangled closet"
	desc = "A closet that is quantum-entangled with one or more closets. Its contents are undetermined until it's opened."
	icon_state = "quantum"
	var/list/obj/structure/closet/quantum/entangled_with = list()
	var/undetermined = TRUE
	var/observation_timer
	
/obj/structure/closet/quantum/Destroy()
	for(var/closet in entangled_with)
		closet.entangled_with -= src
	entangled_with = null
	return ..()
	
/obj/structure/closet/quantum/update_icon()
	if(undetermined)
		icon_state = "quantum-on"
	else
		icon_state = "quantum"
	..()
	
//Checks that all closets are properly unobserved (aka have been closed for a minute)	
/obj/structure/closet/quantum/proc/is_undetermined()
	if(!entangled_with.len)
		return FALSE
	if(!undetermined)
		return FALSE
	return TRUE
	
/obj/structure/closet/quantum/proc/undetermination()
	for(var/closet in get_closet_pool())
		closet.undetermined = TRUE
		closet.update_icon()
	
//Linked closets + this closet	
/obj/structure/closet/quantum/proc/get_closet_pool()
	var/list/obj/structure/closet/quantum/pool = list()
	pool += src
	pool += entangled_with
	return pool
	
//Swap the contents randomly	
/obj/structure/closet/quantum/proc/schrodinger_scramble()
	var/list/quantum_mix = list()
	for(var/closet in get_closet_pool())
		quantum_mix += list(closet.contents)			//Put all contents in a pool
		
	for(var/closet in get_closet_pool())
		undetermined = FALSE
		if(observation_timer)
			deltimer(observation_timer)
		var/picked_content = pick_n_take(quantum_mix)	//Take and remove a random set from the pool
		for(var/X in picked_content)					//Move all items in the set into this locker
			var/atom/movable/A = X
			A.forceMove(closet)
			
/obj/structure/closet/quantum/can_open(mob/living/user, first = TRUE)
	. = ..()
	if(. && first) //First prevents loops
		for(var/closet in entangled_with)
			if(!closet.can_open(null, FALSE))
				to_chat(user, "<span class='warning'>The door seems stuck for some reason.</span>" )
				return FALSE
				
/obj/structure/closet/quantum/can_close(mob/living/user, first = TRUE)
	. = ..()
	if(. && first) //First prevents loops
		for(var/closet in entangled_with)
			if(!closet.can_close(null, FALSE))
				to_chat(user, "<span class='warning'>The door seems stuck for some reason.</span>" )
				return FALSE
			
/obj/structure/closet/quantum/open(mob/living/user, first = TRUE)
	if(first)
		if(opened || !can_open(user))
			return
		if(is_undetermined())
			schrodinger_scramble()
		for(var/closet in entangled_with)
			closet.open(null, FALSE)
	return ..()
	
/obj/structure/closet/quantum/close(mob/living/user, first = TRUE)
	if(first)
		if(!opened || !can_close(user, TRUE))
			return FALSE
		//Timer resets even when not scrambling - leave it unobserved!
		for(var/closet in get_closet_pool())
			if(observation_timer)
				deltimer(observation_timer)
			observation_timer = addtimer(CALLBACK(closet, /obj/structure/closet/quantum.proc/undetermination), 600, TIMER_STOPPABLE)
		for(var/closet in entangled_with)
			closet.close(null, FALSE)
	return ..()
	
	