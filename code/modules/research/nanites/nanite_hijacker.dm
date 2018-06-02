/obj/item/nanite_hijacker
	name = "nanite remote control" //fake name
	desc = "A device that can load nanite programming disks, edit them at will, and imprint them to nanites remotely."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/device.dmi'
	icon_state = "nanite_remote"
	var/obj/item/disk/nanite_program/disk
	var/datum/nanite_program/program

/obj/item/nanite_hijacker/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(disk)
		eject()

/obj/item/nanite_hijacker/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/disk/nanite_program))
		var/obj/item/disk/nanite_program/N = I
		if(disk)
			eject()
		if(user.transferItemToLoc(N, src))
			to_chat(user, "<span class='notice'>You insert [N] into [src]</span>")
			disk = N
			program = N.program
	else
		..()

/obj/item/nanite_hijacker/proc/eject(mob/living/user)
	if(!disk)
		return
	if(!istype(user) || !Adjacent(user) || !user.put_in_hand(disk))
		disk.forceMove(drop_location())
	disk = null
	program = null

/obj/item/nanite_hijacker/afterattack(atom/target, mob/user, etc)
	if(!disk || !disk.program)
		return
	if(isliving(target))
		GET_COMPONENT_FROM(nanites, /datum/component/nanites, target)
		if(nanites)
			to_chat(user, "<span class='notice'>You insert the currently loaded program into [target]'s nanites.</span>")
			nanites.add_program(program.copy())
		else
			to_chat(user, "<span class='notice'>No nanites detected.</span>")

//Same UI as the nanite programmer, as it pretty much does the same
/obj/item/nanite_hijacker/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.hands_state)
	SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "nanite_programmer", "Internal Nanite Programmer", 420, 800, master_ui, state)
		ui.open()

/obj/item/nanite_hijacker/ui_data()
	var/list/data = list()
	data["has_disk"] = istype(disk)
	data["has_program"] = istype(program)
	if(program)
		data["name"] = program.name
		data["desc"] = program.desc
		data["use_rate"] = program.use_rate
		data["can_trigger"] = program.can_trigger
		data["trigger_cost"] = program.trigger_cost
		data["trigger_cooldown"] = program.trigger_cooldown / 10

		data["activated"] = program.activated
		data["activation_delay"] = program.activation_delay
		data["timer"] = program.timer
		data["activation_code"] = program.activation_code
		data["deactivation_code"] = program.deactivation_code
		data["kill_code"] = program.kill_code
		data["trigger_code"] = program.trigger_code
		data["timer_type"] = program.get_timer_type_text()

		data["has_extra_code"] = program.has_extra_code
		data["extra_code"] = program.extra_code
		data["extra_code_name"] = program.extra_code_name
		data["extra_code_min"] = program.extra_code_min
		data["extra_code_max"] = program.extra_code_max
	return data

/obj/item/nanite_hijacker/ui_act(action, params)
	switch(action)
		if("eject")
			eject()
			. = TRUE
		if("toggle_active")
			program.activated = !program.activated //we don't use the activation procs since we aren't in a mob
			if(program.activated)
				program.activation_delay = 0
			. = TRUE
		if("set_code")
			var/new_code = input("Set code (0000-9999):", name, null) as null|num
			if(!isnull(new_code))
				new_code = CLAMP(round(new_code, 1),0,9999)

			var/target_code = params["target_code"]
			switch(target_code)
				if("activation")
					program.activation_code = new_code
				if("deactivation")
					program.deactivation_code = new_code
				if("kill")
					program.kill_code = new_code
				if("trigger")
					program.trigger_code = new_code
			. = TRUE
		if("set_extra_code")
			var/new_code = input("Set [program.extra_code_name] ([program.extra_code_min]-[program.extra_code_max]):", name, null) as null|num
			if(isnull(new_code))
				return
			program.set_extra_code(new_code)
			. = TRUE
		if("set_activation_delay")
			var/delay = input("Set activation delay in seconds (0-1800):", name, program.activation_delay) as null|num
			if(!isnull(delay))
				delay = CLAMP(round(delay, 1),0,1800)
				program.activation_delay = delay
				if(delay)
					program.activated = FALSE
			. = TRUE
		if("set_timer")
			var/timer = input("Set timer in seconds (10-3600):", name, program.timer) as null|num
			if(!isnull(timer))
				timer = CLAMP(round(timer, 1),10,3600)
				program.timer = timer
			. = TRUE
		if("set_timer_type")
			var/new_type = input("Choose the timer effect","Timer Effect") as null|anything in list("Deactivate","Self-Delete","Trigger","Reset Activation Timer")
			if(new_type)
				switch(new_type)
					if("Deactivate")
						program.timer_type = NANITE_TIMER_DEACTIVATE
					if("Self-Delete")
						program.timer_type = NANITE_TIMER_SELFDELETE
					if("Trigger")
						program.timer_type = NANITE_TIMER_TRIGGER
					if("Reset Activation Timer")
						program.timer_type = NANITE_TIMER_RESET
			. = TRUE