/datum/disease
	//Flags
	var/disease_flags = CURABLE|CAN_CARRY

	//Fluff
	var/form = "Virus"
	var/name = "No disease"
	var/desc = ""
	var/agent = "some microbes"
	var/cure_text = ""

	//Stages
	var/stage = 1
	var/max_stages = 0
	var/stage_time_min = 300
	var/stage_time_max = 700
	var/next_stage = 0

	//Other
	var/list/viable_mobtypes = list() //typepaths of viable mobs
	var/mob/living/carbon/affected_mob = null
	var/list/cures = list() //list of cures if the disease has the CURABLE flag, these are reagent ids
	var/infectivity = 65
	var/cure_chance = 8
	
	var/base_infect_chance = 15 //Chance to infect a new host. Modified by the type of infection.
	var/severity = DISEASE_SEVERITY_NONTHREAT
	var/list/required_organs = list()
	var/needs_all_cures = TRUE
	var/list/strain_data = list() //dna_spread special bullshit
	var/infectable_biotypes = MOB_ORGANIC //if the disease can spread on organics, synthetics, or undead
	var/copy_type = null //if this is null, copies will use the type of the instance being copied
	var/natural_immunity_chance = 0 //chance that the disease is instantly cured upon infection, also generating immunity to it
	var/natural_carrier_chance = 0 //chance that the host becomes a healthy carrier for the disease, not suffering from it but still being able to spread it
	var/live_sample = FALSE //tracks if the disease was taken from the blood of a patient when at stage 5
	var/carrier = FALSE //If our host is only a carrier

	var/inherent_traits = list(DISEASE_SPREAD_AIRBORNE, DISEASE_SPREAD_CONTACT_FLUIDS, DISEASE_SPREAD_CONTACT_SKIN)

/datum/disease/New()
	for(var/trait in inherent_traits)
		ADD_TRAIT(src, trait, INHERENT_TRAIT)

/datum/disease/Destroy()
	. = ..()
	if(affected_mob)
		affected_mob.diseases -= src		//remove the datum from the list
		affected_mob.med_hud_set_status()
		affected_mob = null
	SSdisease.active_diseases.Remove(src)

//add this disease if the host does not already have too many
/datum/disease/proc/try_infect(mob/living/infectee, make_copy = TRUE)
	infect(infectee, make_copy)
	return TRUE

//add the disease with no checks
/datum/disease/proc/infect(mob/living/infectee, make_copy = TRUE)
	var/datum/disease/D = make_copy ? Copy() : src
	infectee.diseases += D
	D.affected_mob = infectee
	SSdisease.active_diseases += D //Add it to the active diseases list, now that it's actually in a mob and being processed.

	D.after_add()
	infectee.med_hud_set_status()

	var/turf/source_turf = get_turf(infectee)
	log_virus("[key_name(infectee)] was infected by disease: [src.admin_details()] at [loc_name(source_turf)]")

	if(prob(natural_immunity_chance))
		log_virus("[key_name(infectee)] was naturally immune to the disease: [src.admin_details()] at [loc_name(source_turf)]")
		D.cure()

	if(prob(natural_carrier_chance))
		log_virus("[key_name(infectee)] was naturally a healthy carrier to the disease: [src.admin_details()] at [loc_name(source_turf)]")
		D.carrier = TRUE

/datum/disease/proc/get_infect_chance()
	return base_infect_chance * (stage - 1)

//Return a string for admin logging uses, should describe the disease in detail
/datum/disease/proc/admin_details()
	return "[src.name] : [src.type]"

/datum/disease/proc/stage_act()
	var/cure = has_cure()

	if(carrier && !cure)
		return

	stage = min(stage, max_stages)

	if(!cure)
		if(world.time > next_stage)
			update_stage(min(stage + 1,max_stages))
			next_stage = world.time + rand(stage_time_min, stage_time_max)
	else
		if(prob(cure_chance))
			update_stage(max(stage - 1, 1))
			next_stage = world.time + rand(stage_time_min, stage_time_max)

	if(cure && prob(cure_chance))
		cure()

/datum/disease/proc/update_stage(new_stage)
	stage = new_stage

/datum/disease/proc/has_cure()
	if(!(disease_flags & CURABLE))
		return FALSE

	. = cures.len
	for(var/C_id in cures)
		if(!affected_mob.reagents.has_reagent(C_id))
			.--
	if(!. || (needs_all_cures && . < cures.len))
		return FALSE

//Airborne spreading
/datum/disease/proc/airborne_spread(spread_range = 2, required_spread_types = list(DISEASE_SPREAD_AIRBORNE), force)
	if(!affected_mob)
		return

	if(!force)
		for(var/spread_type in required_spread_types)
			if(!(HAS_TRAIT(src, spread_type)))
				return

	if(HAS_TRAIT(affected_mob, TRAIT_NO_DISEASE_SPREAD))
		return

	if(affected_mob.reagents.has_reagent(/datum/reagent/medicine/spaceacillin) || (affected_mob.satiety > 0 && prob(affected_mob.satiety/10)))
		return

	var/turf/T = affected_mob.loc
	if(istype(T))
		for(var/mob/living/carbon/C in oview(spread_range, affected_mob))
			var/turf/V = get_turf(C)
			if(disease_air_spread_walk(T, V))
				C.airborne_contract_disease(src)

/proc/disease_air_spread_walk(turf/start, turf/end)
	if(!start || !end)
		return FALSE
	while(TRUE)
		if(end == start)
			return TRUE
		var/turf/Temp = get_step_towards(end, start)
		if(!CANATMOSPASS(end, Temp))
			return FALSE
		end = Temp


/datum/disease/proc/cure(add_resistance = TRUE, natural_immunity = FALSE)
	if(affected_mob)
		if(add_resistance && !HAS_TRAIT(src, DISEASE_ABSTRACT) && !(HAS_TRAIT(src, DISEASE_NO_IMMUNITY) && natural_immunity == FALSE))
			affected_mob.disease_resistances |= get_disease_id()
	qdel(src)

/datum/disease/proc/IsSame(datum/disease/D)
	if(istype(D, type))
		return TRUE
	return FALSE


/datum/disease/proc/Copy()
	var/datum/disease/D = new type()
	return D

/datum/disease/proc/after_add()
	next_stage = world.time + rand(stage_time_min, stage_time_max)
	return


/datum/disease/proc/get_disease_id()
	return "[type]"

/datum/disease/proc/get_spread_desc()
	var/list/spread_types = list()
	if(HAS_TRAIT(DISEASE_SPREAD_BLOOD))
		spread_types += "Blood"
	if(HAS_TRAIT(DISEASE_SPREAD_CONTACT_FLUIDS))
		spread_types += "Fluid Contact"
	if(HAS_TRAIT(DISEASE_SPREAD_CONTACT_SKIN))
		spread_types += "Skin Contact"
	if(HAS_TRAIT(DISEASE_SPREAD_CONTACT_AIRBORNE))
		spread_types += "Airborne"
	return english_list(spread_types)

//Use this to compare severities
/proc/get_disease_severity_value(severity)
	switch(severity)
		if(DISEASE_SEVERITY_POSITIVE)
			return 1
		if(DISEASE_SEVERITY_NONTHREAT)
			return 2
		if(DISEASE_SEVERITY_MINOR)
			return 3
		if(DISEASE_SEVERITY_MEDIUM)
			return 4
		if(DISEASE_SEVERITY_HARMFUL)
			return 5
		if(DISEASE_SEVERITY_DANGEROUS)
			return 6
		if(DISEASE_SEVERITY_BIOHAZARD)
			return 7
