/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	resistance_flags = FLAMMABLE
	var/mopping = 0
	var/mopcount = 0
	var/mopcap = 5
	var/mopspeed = 30
	force_string = "robust... against germs"
	var/insertable = TRUE

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(mopcap)


/obj/item/mop/proc/clean(turf/A)
	var/clean_decals = FALSE
	if(reagents.has_reagent("sacid", 1) || reagents.has_reagent("facid", 1))
		SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_IMPRESSIVE)
		clean_decals = TRUE
	if(reagents.has_reagent("cleaner", 1))
		SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRONG)
		clean_decals = TRUE
	if(reagents.has_reagent("water", 1) || reagents.has_reagent("holywater", 1) || reagents.has_reagent("vodka", 1))
		SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
		clean_decals = TRUE
	if(clean_decals)
		for(var/obj/effect/O in A)
			if(is_cleanable(O))
				qdel(O)
	reagents.reaction(A, TOUCH, 10)	//Needed for proper floor wetting.
	reagents.remove_any(1)			//reaction() doesn't use up the reagents

/obj/item/mop/attack(mob/target, mob/living/user)
	if(user.a_intent == INTENT_HELP)
		user.visible_message("[user] gently mops [target] with [src].", "<span class='notice'>You gently mop [target] with [src].</span>")
		reagents.reaction(target, TOUCH, 5)	//Apply chemicals on the mop
		reagents.remove_any(1)
		return
	. = ..()
	reagents.reaction(target, TOUCH, 5)	//Apply chemicals on the mop
	reagents.remove_any(1)

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(reagents.total_volume < 1)
		to_chat(user, "<span class='warning'>Your mop is dry!</span>")
		return

	var/turf/T = get_turf(A)

	if(istype(A, /obj/item/reagent_containers/glass/bucket) || istype(A, /obj/structure/janitorialcart))
		return

	if(T)
		user.visible_message("[user] begins to clean \the [T] with [src].", "<span class='notice'>You begin to clean \the [T] with [src]...</span>")

		if(do_after(user, src.mopspeed, target = T))
			to_chat(user, "<span class='notice'>You finish mopping.</span>")
			clean(T)


/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	else
		return ..()


/obj/item/mop/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	if(insertable)
		J.put_in_cart(src, user)
		J.mymop=src
		J.update_icon()
	else
		to_chat(user, "<span class='warning'>You are unable to fit your [name] into the [J.name].</span>")
		return

/obj/item/mop/cyborg
	insertable = FALSE

/obj/item/mop/advanced
	desc = "The most advanced tool in a custodian's arsenal, complete with a condenser for self-wetting! Just think of all the viscera you will clean up with this!"
	name = "advanced mop"
	mopcap = 10
	icon_state = "advmop"
	item_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 6
	throwforce = 8
	throw_range = 4
	mopspeed = 20
	var/obj/item/mopkit/mopkits = list()
	var/mod_slots = 3
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = "water" //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING
	var/list/refill_options = list("water")

/obj/item/mop/advanced/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mopkit))
		var/obj/item/mopkit/mod = I
		if(mod_slots <= 0)
			to_chat(user, "<span class='warning'>[src] has no mod slots left!</span>")
			return
		var/can_insert = TRUE
		for(var/X in mopkits)
			if(I.type == X.type)
				can_insert = FALSE
				break
		if(can_insert)
			mopkits += mod
			mod_slots--
			mod.mop = src
			mod.forceMove(src)
			mod.on_insert()
			to_chat(user, "<span class='notice'>You install [mod] on [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='warning'>[mod] is already installed on [src]!</span>")
		return
	return ..()
	
/obj/item/mop/advanced/crowbar_act(mob/living/user, obj/item/I)
	. = TRUE
	if(mopkits.len)
		to_chat(user, "<span class='notice'>You pry the modifications out.</span>")
		I.play_tool_sound(src, 100)
		for(var/mod in mopkits)
			mopkits -= mod
			mod_slots++
			mod.on_remove()
			mod.mop = null
			mod.forceMove(drop_location())
		update_icon()
	else
		to_chat(user, "<span class='notice'>There are no modifications currently installed.</span>")
	
/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)
	
/obj/item/mop/advanced/AltClick(mob/user)
	refill_reagent = next_list_item(refill_reagent, refill_options)
	var/datum/reagent/temp = GLOB.chemical_reagents_list[refill_reagent]
	to_chat(user, "<span class='notice'>You set the condenser to [temp.name].</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/update_icon()
	..()
	cut_overlays()
	for(var/mod in mopkits)
		if(mod.overlay_icon)
			add_overlay(mod.overlay_icon)
	
/obj/item/mop/advanced/process()
	if(refill_enabled && (reagents.total_volume < mopcap))
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/mop/advanced/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.</span>")
	if(refill_options.len > 1)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[refill_reagent]
		to_chat(user, "<span class='notice'>Currently dispensing <b>[temp.name]</b>. Alt-Click to switch.</span>")

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/mop/advanced/cyborg
	insertable = FALSE
	
/obj/item/mopkit
	name = "mopkit"
	desc = "An add-on for an advanced mop that modifies its functionality."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "advmop"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/mop/advanced/mop
	var/overlay_icon
	
/obj/item/mopkit/proc/on_insert()
	return
	
/obj/item/mopkit/proc/on_remove()
	return
	
/obj/item/mopkit/fast
	name = "servo-motors mopkit"
	desc = "Doubles the cleaning speed of the mop it's installed on."

/obj/item/mopkit/fast/on_insert()
	mop.mopspeed -= 10
	
/obj/item/mopkit/fast/on_remove()
	mop.mopspeed += 10
	
/obj/item/mopkit/capacity
	name = "liquid tank mopkit"
	desc = "Doubles the reagent capacity of the mop it's installed on."

/obj/item/mopkit/capacity/on_insert()
	mop.mopcap += 10
	
/obj/item/mopkit/capacity/on_remove()
	mop.mopcap -= 10
	
/obj/item/mopkit/bayonet
	name = "bayonet mopkit"
	desc = "Adds a sharp point on the end of a mop, making it viable for melee combat."
	overlay_icon = "mop-bayonet"

/obj/item/mopkit/bayonet/on_insert()
	mop.force = 16
	mop.sharpness = IS_SHARP //Clean cuts
	mop.force_string = null
	mop.attack_verb = list("stabbed", "pierced", "sliced", "cut")
	
/obj/item/mopkit/bayonet/on_remove()
	mop.force = initial(mop.force)
	mop.sharpness = initial(mop.sharpness)
	mop.force_string = initial(mop.force_string)
	mop.attack_verb = initial(mop.attack_verb)
	
/obj/item/mopkit/acid
	name = "acid dispenser mopkit"
	desc = "Adds an acid dispenser to an advanced mop, for the stains that just won't go away."

/obj/item/mopkit/acid/on_insert()
	mop.refill_options += "sacid"
	
/obj/item/mopkit/acid/on_remove()
	mop.refill_options -= "sacid"
	
/obj/item/mopkit/holy
	name = "holy water dispenser mopkit"
	desc = "Adds an automatic water blesser to an advanced mop's water condenser."

/obj/item/mopkit/holy/on_insert()
	mop.refill_options += "holywater"
	
/obj/item/mopkit/holy/on_remove()
	mop.refill_options -= "holywater"
	
/obj/item/mopkit/space_cleaner
	name = "space cleaner dispenser mopkit"
	desc = "Adds a space cleaner dispenser to an advanced mop."

/obj/item/mopkit/space_cleaner/on_insert()
	mop.refill_options += "cleaner"
	
/obj/item/mopkit/space_cleaner/on_remove()
	mop.refill_options -= "cleaner"
	
/obj/item/mopkit/lube
	name = "lube dispenser mopkit"
	desc = "Adds a space lube dispenser to an advanced mop. Who thought this was a good idea?"

/obj/item/mopkit/lube/on_insert()
	mop.refill_options += "lube"
	
/obj/item/mopkit/lube/on_remove()
	mop.refill_options -= "lube"