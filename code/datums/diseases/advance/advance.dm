/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/

/*

	PROPERTIES

 */

/datum/disease/advance
	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

	// NEW VARS
	var/list/stats = list()
	var/list/symptoms = list() // The symptoms of the disease.
	var/list/disease_traits = list() // The traits of the disease.
	var/list/mutators = list(DISEASE_MUTATOR_ALPHA = FALSE, DISEASE_MUTATOR_BETA = FALSE, DISEASE_MUTATOR_GAMMA = FALSE, DISEASE_MUTATOR_DELTA = FALSE)
	var/id = ""
	var/processing = FALSE
	var/mutable = TRUE //set to FALSE to prevent most in-game methods of altering the disease via virology
	var/oldres	//To prevent setting new cures unless resistance changes.

	// The order goes from easy to cure to hard to cure.
	var/static/list/advance_cures = 	list(
									list(	// level 1
										/datum/reagent/copper, /datum/reagent/silver, /datum/reagent/iodine, /datum/reagent/iron, /datum/reagent/carbon
									),
									list(	// level 2
										/datum/reagent/potassium, /datum/reagent/consumable/ethanol, /datum/reagent/lithium, /datum/reagent/silicon, /datum/reagent/bromine
									),
									list(	// level 3
										/datum/reagent/consumable/sodiumchloride, /datum/reagent/consumable/sugar, /datum/reagent/consumable/orangejuice, /datum/reagent/consumable/tomatojuice, /datum/reagent/consumable/milk
									),
									list(	//level 4
										/datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/salglu_solution, /datum/reagent/medicine/epinephrine, /datum/reagent/medicine/charcoal
									),
									list(	//level 5
										/datum/reagent/oil, /datum/reagent/medicine/synaptizine, /datum/reagent/medicine/mannitol, /datum/reagent/drug/space_drugs, /datum/reagent/cryptobiolin
									),
									list(	// level 6
										/datum/reagent/phenol, /datum/reagent/medicine/inacusiate, /datum/reagent/medicine/oculine, /datum/reagent/medicine/antihol
									),
									list(	// level 7
										/datum/reagent/medicine/leporazine, /datum/reagent/toxin/mindbreaker, /datum/reagent/medicine/corazone
									),
									list(	// level 8
										/datum/reagent/pax, /datum/reagent/drug/happiness, /datum/reagent/medicine/ephedrine
									),
									list(	// level 9
										/datum/reagent/toxin/lipolicide, /datum/reagent/medicine/sal_acid
									),
									list(	// level 10
										/datum/reagent/medicine/haloperidol, /datum/reagent/drug/aranesp, /datum/reagent/medicine/diphenhydramine
									),
									list(	//level 11
										/datum/reagent/medicine/modafinil, /datum/reagent/toxin/anacea
									)
								)

/*

	OLD PROCS

 */

/datum/disease/advance/New(is_copy = FALSE)
	refresh(!is_copy)

/datum/disease/advance/Destroy()
	if(processing)
		for(var/datum/disease_property/D in get_properties())
			D.on_end()
	for(var/datum/disease_property/D in get_properties())
		D.remove()
	return ..()

/datum/disease/advance/try_infect(var/mob/living/infectee, make_copy = TRUE)
	//see if we are more transmittable than enough diseases to replace them
	//diseases replaced in this way do not confer immunity
	var/list/advance_diseases = list()
	for(var/datum/disease/advance/P in infectee.diseases)
		advance_diseases += P
	var/replace_num = advance_diseases.len + 1 - DISEASE_LIMIT //amount of diseases that need to be removed to fit this one
	if(replace_num > 0)
		sortTim(advance_diseases, /proc/cmp_advdisease_resistance_asc)
		for(var/i in 1 to replace_num)
			var/datum/disease/advance/competition = advance_diseases[i]
			if(totalTransmittable() > competition.totalResistance())
				competition.cure(FALSE)
			else
				return FALSE //we are not strong enough to bully our way in
	infect(infectee, make_copy)
	return TRUE

/// Activated on each processing tick.
/datum/disease/advance/stage_act()
	..()
	if(carrier)
		return
	var/list/properties = get_properties()
	if(properties.len)
		if(!processing)
			processing = TRUE
			for(var/X in properties)
				var/datum/disease_property/D = X
				D.on_start(src)

		for(var/X in properties)
			var/datum/disease_property/D = X
			D.on_process(src)

/// Procs the symptoms' stage change effects
/datum/disease/advance/update_stage(new_stage)
	for(var/datum/disease_property/D in symptoms)
		D.on_stage_change(new_stage, stage)
	..()
	

/// Compares type then ID.
/datum/disease/advance/is_same(datum/disease/advance/D)

	if(!(istype(D, /datum/disease/advance)))
		return FALSE

	if(get_disease_id() != D.get_disease_id())
		return FALSE
	return TRUE

// Returns the advance disease with a different reference memory.
/datum/disease/advance/Copy()
	var/datum/disease/advance/A = new type(TRUE)
	for(var/datum/disease_property/P in get_properties())
		A.add_property(P.Copy())
	A.id = id
	A.cures = cures.Copy()
	A.mutable = mutable
	A.oldres = oldres
	A.refresh()
	//this is a new disease starting over at stage 1, so processing is not copied
	return A

//Describe this disease to an admin in detail (for logging)
/datum/disease/advance/admin_details()
	var/list/name_symptoms = list()
	for(var/datum/disease_property/symptom/S in symptoms)
		name_symptoms += S.name
	return "[name] sym:[english_list(name_symptoms)] r:[totalResistance()] s:[totalStealth()] ss:[totalStageSpeed()] t:[totalTransmittable()]"

/*

	NEW PROCS

 */

/// Mix the properties of two diseases (the src and the argument)
/datum/disease/advance/proc/mix(datum/disease/advance/D)
	if(!(is_same(D)))
		var/list/possible_properties = shuffle(D.get_properties())
		for(var/datum/disease_property/P in possible_properties)
			add_property(P.Copy())

/// Checks if a given property is already in the disease
/datum/disease/advance/proc/has_property(datum/disease_property/D)
	for(var/datum/disease_property/property in get_properties())
		if(property.type == D.type)
			return TRUE
	return FALSE

/// Will pick a random property within the levels specified. Can optionally generate only symptoms or only traits.
/datum/disease/advance/proc/get_random_property(level_min, level_max, symptom = TRUE, trait = TRUE)
	if(!symptom && !trait)
		return
	if(level_min > level_max)
		return

	var/list/possible_properties = list()
	for(var/X in SSdisease.list_properties)
		var/datum/disease_property/P = X
		if(!symptom && ispath(P, /datum/disease_property/symptom))
			continue
		if(!trait && ispath(P, /datum/disease_property/trait))
			continue
		if(initial(S.naturally_occuring) && initial(S.level) >= level_min && initial(S.level) <= level_max)
			if(!has_property(S))
				possible_properties += S

	if(!possible_properties.len)
		return

	var/selected = pick(possible_properties)
	var/generated = new selected()

	return generated

/// Refreshes the disease, updating stats and applying meta-effects from traits and symptoms. If new_strain is true, a new id and name will be generated as well.
/datum/disease/advance/proc/refresh(new_strain = FALSE)
	update_stats()

	if(new_strain)
		id = null
		var/the_id = get_disease_id()
		if(!SSdisease.archive_diseases[the_id])
			SSdisease.archive_diseases[the_id] = src // So we don't infinite loop
			SSdisease.archive_diseases[the_id] = Copy()
			assign_name()
	
	var/datum/disease/advance/master = SSdisease.archive_diseases[get_disease_id()]
	name = master.name

///Updates disease stats based on traits and symptoms, then updates all the values depening on stats.
/datum/disease/advance/proc/update_stats()
	stats = list("resistance" = 1, "speed" = 1, "infectivity" = 1)

	// Property modifiers are applied first
	for(var/datum/disease_property/P in get_properties())
		stats["resistance"] = CLAMP(stats["resistance"] + P.resistance, 1, 10)
		stats["speed"] = CLAMP(stats["speed"] + P.speed, 1, 10)
		stats["infectivity"] = CLAMP(stats["infectivity"] + P.infectivity, 1, 10)

	// Symptom count modifier
	var/symptom_amount = LAZYLEN(symptoms)
	var/symptom_modifier = 0
	switch(symptom_amount)
		if(1)
			symptom_modifier = 2
		if(2 to 3)
			symptom_modifier = 1
		if(4)
			symptom_modifier = 0
		if(5 to 6)
			symptom_modifier = -1
		if(7 to 8)
			symptom_modifier = -2
	stats["resistance"] = CLAMP(stats["resistance"] + symptom_modifier, 1, 10)
	stats["speed"] = CLAMP(stats["speed"] + symptom_modifier, 1, 10)
	stats["infectivity"] = CLAMP(stats["infectivity"] + symptom_modifier, 1, 10)

	base_infect_chance = stats["infectivity"] * 10 //10% at infectivity 1, 100% at infectivity 10

	//Average time for stage 5: 15 minutes at speed 1, 1.5 minutes at speed 10
	stage_time_min = 1200 / stats["speed"] // 12 seconds at speed 10, 2 minutes at speed 1
	stage_time_max = 2400 / stats["speed"] // 24 seconds at speed 10, 4 minutes at speed 1
	
	//Generated a cure based on resistance
	generate_cure(stats["resistance"])


// Assign the spread type and give it the correct description.
/datum/disease/advance/proc/SetSpread(spread_id)
	switch(spread_id)
		if(DISEASE_SPREAD_NON_CONTAGIOUS)
			spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
			spread_text = "None"
		if(DISEASE_SPREAD_SPECIAL)
			spread_flags = DISEASE_SPREAD_SPECIAL
			spread_text = "None"
		if(DISEASE_SPREAD_BLOOD)
			spread_flags = DISEASE_SPREAD_BLOOD
			spread_text = "Blood"
		if(DISEASE_SPREAD_CONTACT_FLUIDS)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS
			spread_text = "Fluids"
		if(DISEASE_SPREAD_CONTACT_SKIN)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
			spread_text = "On contact"
		if(DISEASE_SPREAD_AIRBORNE)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_AIRBORNE
			spread_text = "Airborne"

/datum/disease/advance/proc/SetSeverity(level_sev)

	switch(level_sev)

		if(-INFINITY to 0)
			severity = DISEASE_SEVERITY_POSITIVE
		if(1)
			severity = DISEASE_SEVERITY_NONTHREAT
		if(2)
			severity = DISEASE_SEVERITY_MINOR
		if(3)
			severity = DISEASE_SEVERITY_MEDIUM
		if(4)
			severity = DISEASE_SEVERITY_HARMFUL
		if(5)
			severity = DISEASE_SEVERITY_DANGEROUS
		if(6 to INFINITY)
			severity = DISEASE_SEVERITY_BIOHAZARD
		else
			severity = "Unknown"


// Will generate a random cure, the more resistance the symptoms have, the harder the cure.
/datum/disease/advance/proc/generate_cure(resistance)
	if(cures.len)
		return
	cures = list(pick(advance_cures[resistance]))
	// Get the cure name from the cure_id
	var/datum/reagent/D = GLOB.chemical_reagents_list[cures[1]]
	cure_text = D.name

// Randomly generate a property between the chosen levels. Can also generate only symptoms or only traits.
/datum/disease/advance/proc/evolve(min_level, max_level, symptom = TRUE, trait = TRUE, ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return
	var/p = safepick(get_random_property(min_level, max_level, symptom, trait))
	if(p)
		add_property(p)
		refresh(TRUE)
	return

/// Randomly removes a property. Can also remove only symptoms or only traits.
/datum/disease/advance/proc/devolve(symptom = TRUE, trait = TRUE, ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return
	if(!symptom && !trait)
		return

	var/list/properties
	if(symptom && !trait)
		properties = symptoms
	else if(trait && !symptom)
		properties = disease_traits
	else
		properties = get_properties()

	if(properties.len > 1)
		var/datum/disease_property/P = pick(properties)
		if(P)
			R.remove()
			refresh(TRUE)

// Name the disease.
/datum/disease/advance/proc/assign_name(name = "Unknown")
	refresh()
	var/datum/disease/advance/A = SSdisease.archive_diseases[get_disease_id()]
	A.name = name
	for(var/datum/disease/advance/AD in SSdisease.active_diseases)
		AD.refresh()

/// Returns the current id of the disease. If it is missing, a new sequential one is generated from the disease controller.
/datum/disease/advance/get_disease_id()
	if(!id)
		id = SSdisease.generate_id()
	return id

/// Calls add_symptom or add_trait based on the property type
/datum/disease/advance/proc/add_property(datum/disease_property/P, overwrite = TRUE)
	if(istype(P, /datum/disease_property/symptom))
		add_symptom(P, overwrite)
	else if(istype(P, /datum/disease_property/trait))
		add_trait(P, overwrite)

/datum/disease/advance/proc/remove_property(datum/disease_property/P)
	P.remove()

/// Add a symptom, if it is over the limit we take a random symptom away and add the new one.
/datum/disease/advance/proc/add_symptom(datum/disease_property/symptom/S, overwrite = TRUE)

	if(has_symptom(S))
		return

	if(symptoms.len < (symptom_limit - 1))
		symptoms += S
	else
		if(overwrite)
			remove_symptom(pick(symptoms))
			symptoms += S

/// Add a trait, if it is over the limit we take a random trait away and add the new one.
/datum/disease/advance/proc/add_trait(datum/disease_trait/T, overwrite = TRUE)

	if(has_trait(T))
		return

	if(disease_traits.len < (trait_limit - 1))
		disease_traits += S
	else
		if(overwrite)
			remove_trait(pick(disease_traits))
			disease_traits += S

/datum/disease/advance/proc/get_properties()
	var/list/properties = symptoms + disease_traits
	return properties
/*

	Static Procs

*/

// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(var/list/D_list)
	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list)
		diseases += A.Copy()

	if(!diseases.len)
		return null
	if(diseases.len <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && diseases.len > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	 // Should be only 1 entry left, but if not let's only return a single entry
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.Refresh(1)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		if(preserve.len)
			R.data["viruses"] = preserve

/proc/AdminCreateVirus(client/user)

	if(!user)
		return

	var/i = VIRUS_SYMPTOM_LIMIT

	var/datum/disease/advance/D = new()
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += SSdisease.list_symptoms.Copy()
	do
		if(user)
			var/symptom = input(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom") in symptoms
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/disease_property/symptom/S = new symptom
				if(!D.HasSymptom(S))
					D.symptoms += S
					i -= 1
	while(i > 0)

	if(D.symptoms.len > 0)

		var/new_name = stripped_input(user, "Name your new disease.", "New Name")
		if(!new_name)
			return
		D.AssignName(new_name)
		D.Refresh()

		for(var/mob/living/carbon/human/H in shuffle(GLOB.alive_mob_list))
			if(!is_station_level(H.z))
				continue
			if(!H.HasDisease(D))
				H.ForceContractDisease(D)
				break

		var/list/name_symptoms = list()
		for(var/datum/disease_property/symptom/S in D.symptoms)
			name_symptoms += S.name
		message_admins("[key_name_admin(user)] has triggered a custom virus outbreak of [D.admin_details()]")
		log_virus("[key_name(user)] has triggered a custom virus outbreak of [D.admin_details()]!")


/datum/disease/advance/proc/totalStageSpeed()
	return properties["stage_rate"]

/datum/disease/advance/proc/totalStealth()
	return properties["stealth"]

/datum/disease/advance/proc/totalResistance()
	return properties["resistance"]

/datum/disease/advance/proc/totalTransmittable()
	return properties["transmittable"]
