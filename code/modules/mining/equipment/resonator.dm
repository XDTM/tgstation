/**********************Resonator**********************/
/obj/item/resonator
	name = "resonator"
	icon = 'icons/obj/mining.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It does increased damage in low pressure."
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
	throwforce = 10
	var/field_type = /obj/effect/temp_visual/resonance
	var/burst_time = 30
	var/delayed_burst = FALSE
	var/fieldlimit = 4
	var/resonance_damage = 20
	var/range = 1
	var/list/fields = list()
	var/quick_burst_mod = 0.8 //Damage multiplier if bursting manually
	
	var/max_mod_capacity = 100
	var/list/modkits = list()

/obj/item/resonator/upgraded
	name = "upgraded resonator"
	desc = "An upgraded version of the resonator that can produce more fields at once, as well as having no damage penalty for bursting a resonance field early."
	icon_state = "resonator_u"
	item_state = "resonator_u"
	max_mod_capacity = 150
	quick_burst_mod = 1

/obj/item/resonator/attack_self(mob/user)
	if(delayed_burst)
		delayed_burst = FALSE
		to_chat(user, "<span class='info'>You set the resonator's fields to detonate after [(burst_time / 10)] seconds.</span>")
	else
		delayed_burst = TRUE
		to_chat(user, "<span class='info'>You set the resonator's fields to detonate after [(burst_time / 10) * 2] seconds.</span>")

/obj/item/resonator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/resonator_modkit))
		var/obj/item/resonator_modkit/MK = I
		MK.install(src, user)
	else
		..()

/obj/item/resonator/proc/get_modkits()
	. = list()
	for(var/A in modkits)
		. += A

/obj/item/resonator/crowbar_act(mob/living/user, obj/item/I)
	. = TRUE
	if(modkits.len)
		to_chat(user, "<span class='notice'>You pry the modifications out.</span>")
		I.play_tool_sound(src, 100)
		for(var/X in modkits)
			var/obj/item/resonator_modkit/MK = X
			MK.uninstall(src)
	else
		to_chat(user, "<span class='notice'>There are no modifications currently installed.</span>")		
		
/obj/item/resonator/proc/CreateResonance(target, mob/user)
	var/turf/T = get_turf(target)
	var/obj/effect/temp_visual/resonance/R = locate(/obj/effect/temp_visual/resonance) in T
	if(R)
		R.damage_multiplier *= quick_burst_mod
		R.burst()
		return
	if(LAZYLEN(fields) < fieldlimit)
		var/actual_burst_time = delayed_burst ? burst_time : (burst_time * 2)
		new field_type(T, user, src, actual_burst_time, resonance_damage)
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/resonator/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(range == 1)
		if(!proximity_flag)
			return
	else if((get_dist(target, user) > range) || (!(target in view(range, user))))
		return
		
	if(check_allowed_items(target, 1))
		CreateResonance(target, user)

//resonance field, crushes rock, damages mobs
/obj/effect/temp_visual/resonance
	name = "resonance field"
	desc = "A resonating field that significantly damages anything inside of it when the field eventually ruptures."
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 50
	var/resonance_damage = 20
	var/damage_multiplier = 1
	var/creator
	var/obj/item/resonator/res

/obj/effect/temp_visual/resonance/Initialize(mapload, set_creator, set_resonator, set_duration, set_damage)
	duration = set_duration
	. = ..()
	creator = set_creator
	res = set_resonator
	resonance_damage = set_damage
	if(res)
		res.fields += src
	playsound(src,'sound/weapons/resonator_fire.ogg',50,1)
	transform = matrix()*0.75
	animate(src, transform = matrix()*1.5, time = duration)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, .proc/burst), duration, TIMER_STOPPABLE)

/obj/effect/temp_visual/resonance/Destroy()
	if(res)
		res.fields -= src
		res = null
	creator = null
	. = ..()

/obj/effect/temp_visual/resonance/proc/check_pressure(turf/proj_turf)
	if(!proj_turf)
		proj_turf = get_turf(src)
	resonance_damage = initial(resonance_damage)
	if(lavaland_equipment_pressure_check(proj_turf))
		name = "strong [initial(name)]"
		resonance_damage *= 3
	else
		name = initial(name)
	resonance_damage *= damage_multiplier

/obj/effect/temp_visual/resonance/proc/burst()
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/resonance_crush(T)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled(creator)
	check_pressure(T)
	playsound(T,'sound/weapons/resonator_blast.ogg',50,1)
	for(var/mob/living/L in T)
		if(creator)
			log_combat(creator, L, "used a resonator field on", "resonator")
		to_chat(L, "<span class='userdanger'>[src] ruptured with you in it!</span>")
		L.apply_damage(resonance_damage, BRUTE)
	qdel(src)

/obj/effect/temp_visual/resonance_crush
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 4

/obj/effect/temp_visual/resonance_crush/Initialize()
	. = ..()
	transform = matrix()*1.5
	animate(src, transform = matrix()*0.1, alpha = 50, time = 4)

/obj/effect/temp_visual/resonance/echo
	name = "echoing resonance field"
	desc = "A resonating field that significantly damages anything inside of it when it eventually ruptures. This one seems to be echoing."
	icon_state = "shield1"
	
/obj/effect/temp_visual/resonance/echo/burst()
	for(var/T in spiral_range_turfs(1, src, 1))
		new /obj/effect/temp_visual/resonance/minor(T, creator, null, duration, resonance_damage)
	..()
		
/obj/effect/temp_visual/resonance/minor
	name = "echoed resonance field"
	desc = "A resonating field that moderately damages anything inside of it when it eventually ruptures. This one seems to be weaker."
	icon_state = "shield1"
	damage_multiplier = 0.3
	
/obj/effect/temp_visual/resonance/safe
	name = "mineral resonance field"
	desc = "A resonating field that ruptures rock when it ruptures, while leaving everything else unharmed."
	icon_state = "shield1"
	damage_multiplier = 0
	
/obj/effect/temp_visual/resonance/unstable
	name = "echoing resonance field"
	desc = "An unstable resonating field that significantly damages anything inside of it when it eventually ruptures. This one seems unstable and prone to collapse."
	icon_state = "shield1"
	
/obj/effect/temp_visual/resonance/unstable/Crossed(atom/movable/AM)
	..()
	burst()
	
/obj/effect/temp_visual/resonance/line
	name = "linear resonance field"
	desc = "A resonating field that significantly damages anything inside of it when it eventually ruptures."
	icon_state = "shield1"
	var/line_count = 3
	
/obj/effect/temp_visual/resonance/line/Initialize(mapload, set_creator, set_resonator, set_duration, set_damage, line_count = 3)
	. = ..()
	if(line_count)
		new /obj/effect/temp_visual/resonance/line(get_step_away(src, creator), set_creator, null, set_duration + 10, set_damage, line_count - 1)
	
/obj/item/resonator_modkit
	name = "resonator modification kit"
	desc = "An upgrade for resonators."
	icon = 'icons/obj/objects.dmi'
	icon_state = "modkit"
	w_class = WEIGHT_CLASS_SMALL
	var/max_copies = 0
	var/denied_type = null
	var/maximum_of_type = 1
	var/cost = 30

/obj/item/resonator_modkit/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Occupies <b>[cost]%</b> of mod capacity.</span>")

/obj/item/resonator_modkit/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/resonator))
		install(A, user)
	else
		..()

/obj/item/resonator_modkit/proc/install(obj/item/resonator/R, mob/user)
	. = TRUE
	if(denied_type || max_copies)
		var/number_of_denied = 0
		var/number_of_copies = 0
		for(var/A in R.get_modkits())
			var/obj/item/resonator_modkit/M = A
			if(istype(M, type))
				number_of_copies++
			if(istype(M, denied_type))
				number_of_denied++
			if(number_of_copies >= max_copies)
				. = FALSE
				break
			if(number_of_denied >= maximum_of_type)
				. = FALSE
				break
	if(R.get_remaining_mod_capacity() >= cost)
		if(.)
			if(!user.transferItemToLoc(src, R))
				return
			to_chat(user, "<span class='notice'>You install the modkit.</span>")
			playsound(loc, 'sound/items/screwdriver.ogg', 100, 1)
			R.modkits += src
		else
			to_chat(user, "<span class='notice'>The modkit you're trying to install would conflict with an already installed modkit. Use a crowbar to remove existing modkits.</span>")
	else
		to_chat(user, "<span class='notice'>You don't have room(<b>[R.get_remaining_mod_capacity()]%</b> remaining, [cost]% needed) to install this modkit. Use a crowbar to remove existing modkits.</span>")
		. = FALSE

/obj/item/resonator_modkit/proc/uninstall(obj/item/resonator/R)
	forceMove(R.drop_location())
	R.modkits -= src
	
/obj/item/resonator_modkit/burst_speed
	name = "pitch booster modkit"
	desc = "Decreases the minimum time required for resonator fields to burst."
	cost = 25
	max_copies = 3
	
/obj/item/resonator_modkit/burst_speed/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.burst_time -= 5

/obj/item/resonator_modkit/burst_speed/uninstall(obj/item/resonator/R)
	..()
	R.burst_time += 5
	
/obj/item/resonator_modkit/field_limit
	name = "field emitter modkit"
	desc = "Increases the amount of fields a resonator can have active at the same time."
	cost = 20
	
/obj/item/resonator_modkit/field_limit/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.field_limit += 2

/obj/item/resonator_modkit/field_limit/uninstall(obj/item/resonator/R)
	..()
	R.field_limit -= 2
		
/obj/item/resonator_modkit/damage
	name = "dissonant field modkit"
	desc = "Increases damage done by resonator fields."
	cost = 35
	
/obj/item/resonator_modkit/damage/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.resonance_damage += 10

/obj/item/resonator_modkit/damage/uninstall(obj/item/resonator/R)
	..()
	R.resonance_damage -= 10
		
/obj/item/resonator_modkit/range
	name = "field projector modkit"
	desc = "Allows a resonator to project fields from further away."
	cost = 30
	
/obj/item/resonator_modkit/range/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.range++

/obj/item/resonator_modkit/damage/uninstall(obj/item/resonator/R)
	..()
	R.range--
	
/obj/item/resonator_modkit/field_type
	denied_type = /obj/item/resonator_modkit/field_type
	maximum_of_type = 1
	
/obj/item/resonator_modkit/field_type/echo
	name = "echoing resonance modkit"
	desc = "Allows a resonator to project echoing fields that emit another ring of fields when they burst."
	cost = 50
	
/obj/item/resonator_modkit/field_type/echo/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.field_type = /obj/effect/temp_visual/resonance/echo

/obj/item/resonator_modkit/field_type/echo/uninstall(obj/item/resonator/R)
	..()
	R.field_type = initial(R.field_type)
	
/obj/item/resonator_modkit/field_type/unstable
	name = "unstable resonance modkit"
	desc = "Allows a resonator to project fields that collapse when something crosses them, but take longer to collapse by themselves."
	cost = 50
	
/obj/item/resonator_modkit/field_type/unstable/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.field_type = /obj/effect/temp_visual/resonance/unstable
		R.burst_time += 20

/obj/item/resonator_modkit/field_type/unstable/uninstall(obj/item/resonator/R)
	..()
	R.field_type = initial(R.field_type)
	R.burst_time -= 20
	
/obj/item/resonator_modkit/field_type/safety
	name = "mineral resonance modkit"
	desc = "Allows a resonator to project fields that only break large amounts of rock and minerals, while being harmless to everything else. Increases field limit."
	cost = 10
	
/obj/item/resonator_modkit/field_type/safety/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.field_type = /obj/effect/temp_visual/resonance/safe
		R.field_limit += 6

/obj/item/resonator_modkit/field_type/safety/uninstall(obj/item/resonator/R)
	..()
	R.field_type = initial(R.field_type)
	R.field_limit -= 6
	
/obj/item/resonator_modkit/field_type/line
	name = "linear resonance modkit"
	desc = "Allows a resonator to project fields that extend in a line."
	cost = 50
	
/obj/item/resonator_modkit/field_type/line/install(obj/item/resonator/R, mob/user)
	. = ..()
	if(.)
		R.field_type = /obj/effect/temp_visual/resonance/line

/obj/item/resonator_modkit/field_type/line/uninstall(obj/item/resonator/R)
	..()
	R.field_type = initial(R.field_type)
	
