/obj/structure/closet/quantum
	name = "quantum-entangled closet"
	desc = "A closet that is quantum-entangled with one or more closets. Its contents are determined only when it's opened, and opening it opens all entangled closets."
	icon_state = "quantum"
	var/list/obj/structure/closet/quantum/entangled_with = list()
	
//Checks that all closets are properly unobserved (closed)	
/obj/structure/closet/quantum/proc/is_undetermined()
	if(!entangled_with.len)
		return FALSE
	for(var/closet in get_closet_pool())
		if(closet.opened)
			return FALSE
	return TRUE
	
//Linked closets + this closet	
/obj/structure/closet/quantum/proc/get_closet_pool()
	var/list/obj/structure/closet/quantum/pool = list()
	pool += src
	pool += entangled_with
	return pool
	
//Swap the contents randomly	
/obj/structure/closet/quantum/proc/schrodinger_scramble()
	var/list/quantum_mix = list()
	for(var/closet in get_closet_pool())				//For each locker
		quantum_mix += list(closet.contents)			//Put all contents in a pool
		
	for(var/closet in get_closet_pool())				//For each locker
		var/picked_content = pick_n_take(quantum_mix)	//Take and remove a random set from the pool
		for(var/X in picked_content)					//Move all items in the set into this locker
			var/atom/movable/A = X
			A.forceMove(closet)
			
/obj/structure/closet/quantum/open(mob/living/user)
	if(opened || !can_open(user))
		return
	if(is_undetermined())
		schrodinger_scramble()
	return ..()
	
	