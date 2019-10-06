/obj/machinery/pathogen_printer
	name = "pathogen printer"
	desc = "Synthesizes pathogens with different structures and gene combinations."
	icon_state = "pathogen"
	icon = 'icons/obj/chemical.dmi'
	circuit = /obj/item/circuitboard/machine/pathogen_printer
	var/obj/machinery/computer/disease_analyzer/linked_analyzer
	var/menu = MENU_OPERATION

/obj/machinery/pathogen_printer/Initialize()
	. = ..()
	find_analyzer()

/obj/machinery/pathogen_printer/proc/find_analyzer()
	for(var/direction in GLOB.cardinals)
		analyzer = locate(/obj/machinery/computer/disease_analyzer, get_step(src, direction))
		if(analyzer)
			linked_analyzer = analyzer
			break



/obj/machinery/pathogen_printer/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.not_incapacitated_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "pathogen_printer", name, ui_x, ui_y, master_ui, state)
		ui.open()

// /obj/machinery/computer/operating/ui_data(mob/user)
// 	var/list/data = list()
// 	data["table"] = table
// 	if(table)
// 		data["menu"] = menu

// 		var/list/surgeries = list()
// 		for(var/X in advanced_surgeries)
// 			var/datum/surgery/S = X
// 			var/list/surgery = list()
// 			surgery["name"] = initial(S.name)
// 			surgery["desc"] = initial(S.desc)
// 			surgeries += list(surgery)
// 		data["surgeries"] = surgeries

// 		data["patient"] = list()
// 		if(table.check_patient())
// 			patient = table.patient
// 			switch(patient.stat)
// 				if(CONSCIOUS)
// 					data["patient"]["stat"] = "Conscious"
// 					data["patient"]["statstate"] = "good"
// 				if(SOFT_CRIT)
// 					data["patient"]["stat"] = "Conscious"
// 					data["patient"]["statstate"] = "average"
// 				if(UNCONSCIOUS)
// 					data["patient"]["stat"] = "Unconscious"
// 					data["patient"]["statstate"] = "average"
// 				if(DEAD)
// 					data["patient"]["stat"] = "Dead"
// 					data["patient"]["statstate"] = "bad"
// 			data["patient"]["health"] = patient.health
// 			data["patient"]["blood_type"] = patient.dna.blood_type
// 			data["patient"]["maxHealth"] = patient.maxHealth
// 			data["patient"]["minHealth"] = HEALTH_THRESHOLD_DEAD
// 			data["patient"]["bruteLoss"] = patient.getBruteLoss()
// 			data["patient"]["fireLoss"] = patient.getFireLoss()
// 			data["patient"]["toxLoss"] = patient.getToxLoss()
// 			data["patient"]["oxyLoss"] = patient.getOxyLoss()
// 			if(patient.surgeries.len)
// 				data["procedures"] = list()
// 				for(var/datum/surgery/procedure in patient.surgeries)
// 					var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
// 					var/chems_needed = surgery_step.get_chem_list()
// 					var/alternative_step
// 					var/alt_chems_needed = ""
// 					if(surgery_step.repeatable)
// 						var/datum/surgery_step/next_step = procedure.get_surgery_next_step()
// 						if(next_step)
// 							alternative_step = capitalize(next_step.name)
// 							alt_chems_needed = next_step.get_chem_list()
// 						else
// 							alternative_step = "Finish operation"
// 					data["procedures"] += list(list(
// 						"name" = capitalize("[parse_zone(procedure.location)] [procedure.name]"),
// 						"next_step" = capitalize(surgery_step.name),
// 						"chems_needed" = chems_needed,
// 						"alternative_step" = alternative_step,
// 						"alt_chems_needed" = alt_chems_needed
// 					))
// 	return data

// /obj/machinery/computer/operating/ui_act(action, params)
// 	if(..())
// 		return
// 	switch(action)
// 		if("change_menu")
// 			menu = text2num(params["menu"])
// 			. = TRUE
// 		if("sync")
// 			sync_surgeries()
// 			. = TRUE
// 	. = TRUE
