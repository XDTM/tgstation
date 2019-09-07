/datum/design/virology
	name = "None"
	desc = "Warn a coder if you see this."
	id = "default_virology"
	build_type = PATHOGEN_PRINTER
	construction_time = 50
	category = list()
	var/program_type = /datum/nanite_program

/datum/design/virology/pathogen
	name = "Generic Pathogen"
	id = "default_pathogen"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_pathogen"
	var/pathogen_type = /datum/pathogen

/datum/design/virology/property
	name = "Generic Property"
	id = "default_property"
	var/property_type = /datum/disease_property

/datum/design/virology/property/symptom
	name = "Generic Symptom"
	desc = "Warn a coder if you see this."
	id = "default_symptom"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_symptom"
	var/property_type = /datum/disease_property/symptom

/datum/design/virology/property/trait
	name = "Generic Trait"
	id = "default_disease_trait"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_trait"
	var/property_type = /datum/disease_property/trait
