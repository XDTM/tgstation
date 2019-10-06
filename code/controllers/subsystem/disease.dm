SUBSYSTEM_DEF(disease)
	name = "Disease"
	flags = SS_NO_FIRE

	var/list/active_diseases = list() //List of Active disease in all mobs; purely for quick referencing.
	var/list/diseases
	var/list/archive_diseases = list()

	var/current_id = 0

	var/static/list/list_properties = subtypesof(/datum/disease_property/symptom) + subtypesof(/datum/disease_property/trait)

/datum/controller/subsystem/disease/PreInit()
	if(!diseases)
		diseases = subtypesof(/datum/disease)

/datum/controller/subsystem/disease/Initialize(timeofday)
	var/list/all_common_diseases = diseases - typesof(/datum/disease/advance)
	for(var/common_disease_type in all_common_diseases)
		var/datum/disease/prototype = new common_disease_type()
		archive_diseases[prototype.get_disease_id()] = prototype
	return ..()

/datum/controller/subsystem/disease/stat_entry(msg)
	..("P:[active_diseases.len]")

/datum/controller/subsystem/disease/proc/generate_id()
	current_id++
	return current_id

/datum/controller/subsystem/disease/proc/get_disease_name(id)
	var/datum/disease/A = archive_diseases[id]
	if(A.name)
		return A.name
	else
		return "Unknown"
