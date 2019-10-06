#define MAIN_SCREEN 1
#define PROPERTY_DETAILS 2
#define RESEARCH_SCREEN 3

/obj/machinery/computer/disease_analyzer
	name = "Disease Analyzer"
	desc = "Analyzes diseases, using their data and machine learning to generate pathogen DNA designs."
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "viro_analyzer_idle"
	use_power = TRUE
	idle_power_usage = 20
	resistance_flags = ACID_PROOF
	circuit = /obj/item/circuitboard/computer/pandemic
	ui_x = 700
	ui_y = 500

	var/wait
	var/mode = MAIN_SCREEN
	var/datum/disease_property/symptom/selected_symptom
	var/obj/item/reagent_containers/beaker

/obj/machinery/computer/disease_analyzer/Initialize()
	. = ..()
	update_icon()

/obj/machinery/computer/disease_analyzer/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/computer/disease_analyzer/examine(mob/user)
	. = ..()
	if(beaker)
		var/is_close
		if(Adjacent(user)) //don't reveal exactly what's inside unless they're close enough to see the UI anyway.
			. += "It contains \a [beaker]."
			is_close = TRUE
		else
			. += "It has a beaker inside it."
		. += "<span class='info'>Alt-click to eject [is_close ? beaker : "the beaker"].</span>"

/obj/machinery/computer/disease_analyzer/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE))
		eject_beaker()

/obj/machinery/computer/disease_analyzer/handle_atom_del(atom/A)
	if(A == beaker)
		beaker = null
		update_icon()
	return ..()

/obj/machinery/computer/disease_analyzer/proc/get_disease_data(datum/reagent/blood/B)
	. = list()
	var/list/diseases = B.get_diseases()
	var/index = 1
	for(var/disease in diseases)
		var/datum/disease/D = disease
		if(!istype(D))
			continue

		var/list/this = list()
		this["name"] = SSdisease.get_disease_name(D.get_disease_id())
		if(istype(D, /datum/disease/advance))
			var/datum/disease/advance/A = D
			this["is_adv"] = TRUE
			this["symptoms"] = list()

			//Pathogen Details
			var/datum/pathogen/P = A.pathogen
			var/list/pathogen = list()
			pathogen["name"] = P.name
			pathogen["desc"] = P.desc
			pathogen["max_symptoms"] = P.max_symptoms
			pathogen["max_traits"] = P.max_traits
			this["pathogen"] = list(pathogen)

			//Symptom List
			var/symptom_index = 1
			for(var/symptom in A.symptoms)
				var/datum/disease_property/symptom/S = symptom
				var/list/this_symptom = list()
				this_symptom["name"] = S.name
				this_symptom["desc"] = S.desc
				this_symptom["sym_index"] = symptom_index
				symptom_index++
				this["symptoms"] += list(this_symptom)
			var/trait_index = 1

			//Trait List
			for(var/trait in A.disease_traits)
				var/datum/disease_property/trait/S = trait
				var/list/this_trait = list()
				this_trait["name"] = S.name
				this_trait["desc"] = S.desc
				this_trait["trait_index"] = trait_index
				trait_index++
				this["traits"] += list(this_trait)
			
			//Total Stats
			this["resistance"] = A.stats["resistance"]
			this["speed"] = A.stats["speed"]
			this["infectivity"] = A.stats["infectivity"]

			//Active Mutators
			var/list/mutators = list()
			mutators["alpha"] = HAS_TRAIT(A, DISEASE_MUTATOR_ALPHA)
			mutators["beta"] = HAS_TRAIT(A, DISEASE_MUTATOR_BETA)
			mutators["gamma"] = HAS_TRAIT(A, DISEASE_MUTATOR_GAMMA)
			mutators["delta"] = HAS_TRAIT(A, DISEASE_MUTATOR_DELTA)
			mutators["epsilon"] = HAS_TRAIT(A, DISEASE_MUTATOR_EPSILON)
			this["mutators"] = list(mutators)

		this["index"] = index++
		this["agent"] = D.agent
		this["description"] = D.desc || "none"
		this["spread"] = D.get_spread_desc() || "none"
		this["cure"] = D.cure_text || "none"

		. += list(this)

/obj/machinery/computer/pandemic/proc/get_property_data(datum/disease_property/P)
	. = list()
	var/list/this = list()
	this["name"] = P.name
	this["desc"] = P.desc
	this["resistance"] = P.resistance
	this["speed"] = P.speed
	this["infectivity"] = P.infectivity
	if(istype(P, /datum/disease_property/symptom))
		var/datum/disease_property/symptom/S = P
		this["threshold_desc"] = S.threshold_desc
	. += this

/obj/machinery/computer/pandemic/proc/get_resistance_data(datum/reagent/blood/B)
	. = list()
	if(!islist(B.data["resistances"]))
		return
	var/list/resistances = B.data["resistances"]
	for(var/id in resistances)
		var/list/this = list()
		var/datum/disease/D = SSdisease.archive_diseases[id]
		if(D)
			this["id"] = id
			this["name"] = D.name

		. += list(this)

/obj/machinery/computer/pandemic/update_icon()
	if(beaker)
		add_overlay("viro_analyzer_sample")
	else
		cut_overlays()

	if(stat & BROKEN)
		icon_state = "viro_analyzer_broken"
		return
	
	if(stat & NOPOWER)
		icon_state = "viro_analyzer_nopower"
		return

/obj/machinery/computer/pandemic/proc/eject_beaker()
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null
		update_icon()

/obj/machinery/computer/pandemic/ui_interact(mob/user, ui_key = "main", datum/tgui/ui, force_open = FALSE, datum/tgui/master_ui, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "pandemic", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/computer/pandemic/ui_data(mob/user)
	var/list/data = list()
	data["is_ready"] = !wait
	data["mode"] = mode
	switch(mode)
		if(MAIN_SCREEN)
			if(beaker)
				data["has_beaker"] = TRUE
				if(!beaker.reagents.total_volume || !beaker.reagents.reagent_list)
					data["beaker_empty"] = TRUE
				var/datum/reagent/blood/B = locate() in beaker.reagents.reagent_list
				if(B)
					data["has_blood"] = TRUE
					data[/datum/reagent/blood] = list()
					data[/datum/reagent/blood]["dna"] = B.data["blood_DNA"] || "none"
					data[/datum/reagent/blood]["type"] = B.data["blood_type"] || "none"
					data["diseases"] = get_disease_data(B)
					data["resistances"] = get_resistance_data(B)
		if(PROPERTY_DETAILS)
			data["property"] = get_property_data(selected_symptom)

	return data

/obj/machinery/computer/pandemic/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("eject_beaker")
			eject_beaker()
			. = TRUE
		if("empty_beaker")
			if(beaker)
				beaker.reagents.clear_reagents()
			. = TRUE
		if("empty_eject_beaker")
			if(beaker)
				beaker.reagents.clear_reagents()
				eject_beaker()
			. = TRUE
		if("rename_disease")
			var/id = get_virus_id_by_index(text2num(params["index"]))
			var/datum/disease/advance/A = SSdisease.archive_diseases[id]
			if(!A.mutable)
				return
			if(A)
				var/new_name = sanitize_name(stripped_input(usr, "Name the disease", "New name", "", MAX_NAME_LEN))
				if(!new_name || ..())
					return
				A.assign_name(new_name)
				. = TRUE
		if("create_culture_bottle")
			if (wait)
				return
			var/id = get_virus_id_by_index(text2num(params["index"]))
			var/datum/disease/advance/A = SSdisease.archive_diseases[id]
			if(!istype(A) || !A.mutable)
				to_chat(usr, "<span class='warning'>ERROR: Cannot replicate virus strain.</span>")
				return
			A = A.Copy()
			var/list/data = list("viruses" = list(A))
			var/obj/item/reagent_containers/glass/bottle/B = new(drop_location())
			B.name = "[A.name] culture bottle"
			B.desc = "A small bottle. Contains [A.agent] culture in synthblood medium."
			B.reagents.add_reagent(/datum/reagent/blood, 20, data)
			wait = TRUE
			update_icon()
			var/turf/source_turf = get_turf(src)
			log_virus("A culture bottle was printed for the virus [A.admin_details()] at [loc_name(source_turf)] by [key_name(usr)]")
			addtimer(CALLBACK(src, .proc/reset_replicator_cooldown), 50)
			. = TRUE
		if("create_vaccine_bottle")
			if (wait)
				return
			var/id = params["index"]
			var/datum/disease/D = SSdisease.archive_diseases[id]
			var/obj/item/reagent_containers/glass/bottle/B = new(drop_location())
			B.name = "[D.name] vaccine bottle"
			B.reagents.add_reagent(/datum/reagent/vaccine, 15, list(id))
			wait = TRUE
			update_icon()
			addtimer(CALLBACK(src, .proc/reset_replicator_cooldown), 200)
			. = TRUE
		if("symptom_details")
			var/picked_symptom_index = text2num(params["picked_symptom"])
			var/index = text2num(params["index"])
			var/datum/disease/advance/A = get_by_index("viruses", index)
			var/datum/disease_property/symptom/S = A.symptoms[picked_symptom_index]
			mode = SYMPTOM_DETAILS
			selected_symptom = S
			. = TRUE
		if("back")
			mode = MAIN_SCREEN
			selected_symptom = null
			. = TRUE


/obj/machinery/computer/pandemic/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		if(stat & (NOPOWER|BROKEN))
			return
		if(beaker)
			to_chat(user, "<span class='warning'>A container is already loaded into [src]!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return

		beaker = I
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		update_icon()
	else
		return ..()

/obj/machinery/computer/pandemic/on_deconstruction()
	eject_beaker()
	. = ..()

#undef MAIN_SCREEN
#undef PROPERTY_DETAILS
#undef RESEARCH_SCREEN
