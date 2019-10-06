///Pathogens: form the 'core' of a disease, determine how many symptoms and traits they can hold, and can have default spread methods and traits as well as stat modifiers.
/datum/pathogen
	var/name = "Pathogen"
	var/desc = "This should not be visible!"
	var/spread_desc = "" ///Describes the default spread method
	var/trait_desc = "" ///Describes what any extra initial traits will do

	var/max_symptoms = 4
	var/max_traits = 4

	var/default_traits = list()

	var/resistance = 0
	var/speed = 0
	var/infectivity = 0


/datum/pathogen/ab_murion
	name = "AB Murion"
	desc = "The current intergalactic standard for disease research, striking a good balance between core and membrane. Recommended by 9 virologists out of 10."
	spread_desc = "Fluid Contact"
	max_symptoms = 4
	max_traits = 5
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS)

/datum/pathogen/zy_murion
	name = "ZY Murion"
	desc = "A variant of the AB Murion, mutated to spread by skin contact instead of fluids."
	spread_desc = "Skin Contact"
	max_symptoms = 4
	max_traits = 5
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_SKIN)

/datum/pathogen/csal_41
	name = "CSAL-41"
	desc = "A pathogen blueprint resulting from bio-miniaturization research. There is less space to work with, but the reduced size has significant benefits in efficiency and infectivity."
	spread_desc = "Airborne"
	max_symptoms = 2
	max_traits = 4
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_AIRBORNE)
	resistance = 2
	speed = 2
	infectivity = 4

/datum/pathogen/csal_45
	name = "CSAL-45"
	desc = "A modern variant of CSAL-41, this pathogen offers a compromise between miniaturization and capacity."
	spread_desc = "Airborne"
	max_symptoms = 3
	max_traits = 4
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_AIRBORNE)
	infectivity = 4

/datum/pathogen/mono_gtr
	name = "Mono-GTR"
	desc = "A pathogen consisting of a specialized core surrounded by several layers of support structures. It was initially used to spread vaccinations to livestock."
	spread_desc = "Fluid Contact"
	max_symptoms = 1
	max_traits = 8
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS)

/datum/pathogen/mono_pwr
	name = "Mono-PWR"
	desc = "A variant of Mono-GTR geared towards maximizing efficiency instead of support structures."
	spread_desc = "Fluid Contact"
	max_symptoms = 1
	max_traits = 4
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS)
	resistance = 4
	speed = 4
	infectivity = 4

/datum/pathogen/duke_h
	name = "DUKE.h"
	desc = "A pathogen designed to be the noble gas equivalent of virology. It has no natural spread mechanism, preventing unintentional outbreaks. \
	However, these safety features take a heavy toll on the disease's growth speed."
	spread_desc = "Direct Blood Transfer"
	max_symptoms = 4
	max_traits = 5
	default_traits = list(DISEASE_SPREAD_BLOOD)
	speed = -4

/datum/pathogen/count_d
	name = "COUNT.d"
	desc = "A variant of the more common DUKE.h, this pathogen prevents infection even through blood contact by synchronizing to their host's metabolism. The disease needs to be administered \
	from the original sample to work."
	spread_desc = "Direct Blood Transfer"
	max_symptoms = 4
	max_traits = 5
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_FIXED_HOST)
	speed = -4

/datum/pathogen/large_8
	name = "LARGE-8"
	desc = "A pathogen with an uncommon design, placing the support structures at the center and its multiple cores in an octagonal pattern around it."
	spread_desc = "Fluid Contact"
	max_symptoms = 8
	max_traits = 3
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS)

/datum/pathogen/huge_16
	name = "HUGE-16"
	desc = "A variation of LARGE-8, this massive pathogen has an extreme amount of space for both cores and support structures, but suffers greatly in terms of base efficiency."
	spread_desc = "Fluid Contact"
	max_symptoms = 8
	max_traits = 8
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS)
	resistance = -6
	speed = -6
	infectivity = -6

/datum/pathogen/dawn
	name = "Dawn"
	desc = "The result of the infamous project Dawn: a variation of the AB Murion which is nearly undetectable by medical scans, while being more efficient at the same time. \
	Its use was heavily restricted after several outbreaks from research institutes proved nearly impossible to eradicate."
	spread_desc = "Fluid Contact"
	trait_desc = "Undetectable by medical scanners and HUDs."
	max_symptoms = 4
	max_traits = 4
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS, DISEASE_HIDDEN_HUD, DISEASE_HIDDEN_SCANNER)
	speed = 2
	infectivity = 2

/datum/pathogen/dusk
	name = "Dusk"
	desc = "A black market version of the Dawn project, resulting in an even more dangerous pathogen."
	spread_desc = "Fluid Contact"
	trait_desc = "Undetectable by medical scanners and HUDs."
	max_symptoms = 3
	max_traits = 3
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS, DISEASE_SPREAD_CONTACT_SKIN, DISEASE_HIDDEN_HUD, DISEASE_HIDDEN_SCANNER)
	speed = 4
	infectivity = 4

/datum/pathogen/midnight
	name = "Midnight"
	desc = "\[REDACTED\]"
	spread_desc = "Airborne"
	trait_desc = "Undetectable by medical scanners and HUDs. Contains a free Epsilon mutator."
	max_symptoms = 1
	max_traits = 3
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_AIRBORNE, DISEASE_HIDDEN_HUD, DISEASE_HIDDEN_SCANNER, DISEASE_MUTATOR_EPSILON)
	speed = 2
	infectivity = 2

/datum/pathogen/syn_dr_i11
	name = "SYN:Dr_I11"
	desc = "Developed by an unnamed syndicate doctor, this pathogen has severely interdependent mechanisms which limit its cusomizability, but give it a spectacular boost in efficiency."
	spread_desc = "Skin Contact"
	max_symptoms = 2
	max_traits = 2
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_SKIN)
	resistance = 8
	speed = 8
	infectivity = 8

/datum/pathogen/syn_dr_0m3
	name = "SYN:Dr_0M3"
	desc = "A modification of SYN:Dr_I11 geared towards mutators instead of pure efficiency."
	spread_desc = "Skin Contact"
	trait_desc = "Contains Alpha, Beta and Gamma mutators."
	max_symptoms = 2
	max_traits = 2
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_SKIN, DISEASE_MUTATOR_ALPHA, DISEASE_MUTATOR_BETA, DISEASE_MUTATOR_GAMMA)
	resistance = 5
	speed = 5
	infectivity = 5

/datum/pathogen/grey
	name = "GREY"
	desc = "Reverse-engineered from abductor biotechnology, this pathogen is extremely infective, while still having a high core capacity."
	spread_desc = "Airborne, Skin Contact, Fluid Contact"
	trait_desc = "Can infect corpses and thrive within dead hosts. Cured hosts will not gain immunity."
	max_symptoms = 4
	max_traits = 4
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS, DISEASE_SPREAD_CONTACT_SKIN, DISEASE_SPREAD_AIRBORNE, DISEASE_NO_IMMUNITY, DISEASE_PROCESS_DEAD)
	infectivity = 5

/datum/pathogen/black
	name = "BLACK"
	desc = "Perfection made pathogen. The result of cross-examining ultra-high tech NT biotechnology, underground military bioterror research, and scans of advanced abductor cyber-biology."
	spread_desc = "Airborne, Skin Contact, Fluid Contact"
	trait_desc = "Can infect corpses and thrive within dead hosts. Cured hosts will not gain immunity."
	max_symptoms = 4
	max_traits = 3
	default_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_FLUIDS, DISEASE_SPREAD_CONTACT_SKIN, DISEASE_SPREAD_AIRBORNE, DISEASE_NO_IMMUNITY, DISEASE_PROCESS_DEAD)
	resistance = 12
	speed = 12
	infectivity = 12
