/datum/design/virology
	name = "None"
	desc = "Warn a coder if you see this."
	id = "default_virology"
	build_type = PATHOGEN_PRINTER
	construction_time = 50
	category = list()
	var/program_type = /datum/nanite_program

/datum/design/virology/property
	name = "Generic Property"
	id = "default_property"
	var/property_type = /datum/disease_property

///////////////////////////////////////////////////////////
///////////////////////////SYMPTOMS////////////////////////
///////////////////////////////////////////////////////////
/datum/design/virology/property/symptom
	name = "Generic Symptom"
	desc = "Warn a coder if you see this."
	id = "default_symptom"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_symptom"
	property_type = /datum/disease_property/symptom

/datum/design/virology/property/symptom/beard
	name = "Facial Hypertrichosis"
	desc = "The disease increases hair production significantly, causing rapid beard growth."
	id = "symptom_beard"
	property_type = /datum/disease_property/symptom/beard

/datum/design/virology/property/symptom/choking
	name = "Choking"
	desc = "The disease causes inflammation of the host's air conduits, leading to intermittent choking."
	id = "symptom_choking"
	property_type = /datum/disease_property/symptom/choking

/datum/design/virology/property/symptom/confusion
	name = "Auricolar Burst"
	desc = "The disease causes occasional bursts of air in the ear's labyrinth, causing dizziness and lack of balance."
	id = "symptom_confusion"
	property_type = /datum/disease_property/symptom/confusion

/datum/design/virology/property/symptom/fever
	name = "Fever"
	desc = "The disease causes a febrile response from the host, raising its natural body temperature."
	id = "symptom_fever"
	property_type = /datum/disease_property/symptom/fever

/datum/design/virology/property/symptom/cooling
	name = "Cooling"
	desc = "The disease inhibits the body's thermoregulation, cooling the body down."
	id = "symptom_cooling"
	property_type = /datum/disease_property/symptom/cooling

/datum/design/virology/property/symptom/cough
	name = "Cough"
	desc = "The disease irritates the throat of the host, causing occasional coughing."
	id = "symptom_cough"
	property_type = /datum/disease_property/symptom/cough

/datum/design/virology/property/symptom/deafness
	name = "Deafness"
	desc = "The disease causes inflammation of the eardrums, causing intermittent deafness."
	id = "symptom_deafness"
	property_type = /datum/disease_property/symptom/deafness

/datum/design/virology/property/symptom/disfiguration
	name = "Facial Contortion"
	desc = "The disease causes the host's facial muscles to contract in unnatural shapes, distorting their features to the point of being unrecognizable."
	id = "symptom_disfiguration"
	property_type = /datum/disease_property/symptom/disfiguration

/datum/design/virology/property/symptom/fire
	name = "Spontaneous Combustion"
	desc = "The disease turns fat into an extremely flammable compound, and raises the body's temperature, making the host burst into flames spontaneously."
	id = "symptom_fire"
	property_type = /datum/disease_property/symptom/fire

/datum/design/virology/property/symptom/flesh_eating
	name = "Necrotizing Fasciitis"
	desc = "The disease aggressively attacks body cells, necrotizing tissues and organs."
	id = "symptom_flesh_eating"
	property_type = /datum/disease_property/symptom/flesh_eating

/datum/design/virology/property/symptom/genetic_mutation
	name = "DNA Mutation"
	desc = "The disease bonds with the DNA of the host, causing random mutations until removed."
	id = "symptom_genetic_mutation"
	property_type = /datum/disease_property/symptom/genetic_mutation

/datum/design/virology/property/symptom/hallucinations
	name = "Hallucinations"
	desc = "The disease stimulates the brain, causing occasional hallucinations."
	id = "symptom_hallucinations"
	property_type = /datum/disease_property/symptom/hallucinations

/datum/design/virology/property/symptom/headache
	name = "Headache"
	desc = "The disease causes inflammation inside the brain, causing constant headaches."
	id = "symptom_headache"
	property_type = /datum/disease_property/symptom/headache

/datum/design/virology/property/symptom/heal_starlight
	name = "Starlight Condensation"
	desc = "The disease reacts to direct starlight, producing regenerative chemicals. Works best against toxin-based damage."
	id = "symptom_heal_starlight"
	property_type = /datum/disease_property/symptom/heal/starlight

/datum/design/virology/property/symptom/heal_chem
	name = "Phagocyte"
	desc = "The disease rapidly breaks down any foreign chemicals in the bloodstream."
	id = "symptom_heal_chem"
	property_type = /datum/disease_property/symptom/heal/chem

/datum/design/virology/property/symptom/heal_metabolism
	name = "Parallel Metabolization"
	desc = "The disease causes the host's metabolism to accelerate rapidly, making them metabolize twice as fast, but also causing increased hunger."
	id = "symptom_heal_metabolism"
	property_type = /datum/disease_property/symptom/heal/metabolism

/datum/design/virology/property/symptom/heal_darkness
	name = "Nocturnal Regeneration"
	desc = "The disease is able to mend the host's flesh when in conditions of low light, repairing physical damage. More effective against brute damage."
	id = "symptom_heal_darkness"
	property_type = /datum/disease_property/symptom/heal/darkness

/datum/design/virology/property/symptom/heal_coma
	name = "Regenerative Coma"
	desc = "The disease causes the host to fall into a coma when severely damaged, then rapidly fixes the damage."
	id = "symptom_heal_coma"
	property_type = /datum/disease_property/symptom/heal/coma

/datum/design/virology/property/symptom/heal_water
	name = "Tissue Hydration"
	desc = "The disease uses excess water inside and outside the body to repair damaged tissue cells. More effective when using holy water and against burns."
	id = "symptom_heal_water"
	property_type = /datum/disease_property/symptom/heal/water

/datum/design/virology/property/symptom/heal_plasma
	name = "Plasma Fixation"
	desc = "The disease draws plasma from the atmosphere and from inside the body to heal and stabilize body temperature."
	id = "symptom_heal_plasma"
	property_type = /datum/disease_property/symptom/heal/plasma

/datum/design/virology/property/symptom/heal_radiation
	name = "Radioactive Resonance"
	desc = "The disease uses radiation to fix damage through local cellular mutations."
	id = "symptom_heal_radiation"
	property_type = /datum/disease_property/symptom/heal/radiation

/datum/design/virology/property/symptom/itching
	name = "Itching"
	desc = "The disease irritates the skin, causing annoying itching."
	id = "symptom_itching"
	property_type = /datum/disease_property/symptom/itching

/datum/design/virology/property/symptom/nano_boost
	name = "Nano-symbiosis"
	desc = "The disease reacts to nanites in the host's bloodstream by enhancing their replication cycle."
	id = "symptom_nano_boost"
	property_type = /datum/disease_property/symptom/nano_boost

/datum/design/virology/property/symptom/nano_destroy
	name = "Silicolysis"
	desc = "The disease reacts to nanites in the host's bloodstream by attacking and consuming them."
	id = "symptom_nano_destroy"
	property_type = /datum/disease_property/symptom/nano_destroy

/datum/design/virology/property/symptom/narcolepsy
	name = "Narcolepsy"
	desc = "The disease causes a hormone imbalance, making the host sleepy and narcoleptic."
	id = "symptom_narcolepsy"
	property_type = /datum/disease_property/symptom/narcolepsy

/datum/design/virology/property/symptom/oxygen
	name = "Self-Respiration"
	desc = "The disease rapidly synthesizes oxygen, effectively removing the need for breathing as long as the host's metabolism and circulation function properly."
	id = "symptom_oxygen"
	property_type = /datum/disease_property/symptom/oxygen

/datum/design/virology/property/symptom/neural_restoration
	name = "Neural Restoration"
	desc = "The disease strengthens the bonds between neurons, curing brain damage and healing minor traumas."
	id = "symptom_neural_restoration"
	property_type = /datum/disease_property/symptom/neural_restoration

/datum/design/virology/property/symptom/shedding
	name = "Alopecia"
	desc = "The disease causes rapid shedding of head and body hair."
	id = "symptom_shedding"
	property_type = /datum/disease_property/symptom/shedding

/datum/design/virology/property/symptom/sneeze
	name = "Sneezing"
	desc = "The disease causes irritation of the nasal cavity, making the host sneeze occasionally, spreading the disease in a cone if airborne."
	id = "symptom_sneeze"
	property_type = /datum/disease_property/symptom/sneeze

/datum/design/virology/property/symptom/sneeze
	name = "Sneezing"
	desc = "The disease causes irritation of the nasal cavity, making the host sneeze occasionally, spreading the disease in a cone if airborne."
	id = "symptom_sneeze"
	property_type = /datum/disease_property/symptom/sneeze

/datum/design/virology/property/symptom/resistance_infection
	name = "Local Adaptation"
	desc = "The disease agents can individually adapt to external conditions, increasing their resistance and infectivity at the cost of speed."
	id = "symptom_resistance_infection"
	property_type = /datum/disease_property/symptom/resistance_infection

/datum/design/virology/property/symptom/resistance_speed
	name = "Synergetic Rooting"
	desc = "The disease specializes itself to thrive within its current host, increasing speed and resistance but reducing infectivity."
	id = "symptom_resistance_speed"
	property_type = /datum/disease_property/symptom/resistance_speed

/datum/design/virology/property/symptom/infection_speed
	name = "Auto-Mitosis"
	desc = "The disease has a backup autonomous reproduction mechanism, increasing its speed and infectivity but reducing its resistance."
	id = "symptom_infection_speed"
	property_type = /datum/disease_property/symptom/infection_speed

/datum/design/virology/property/symptom/life_support
	name = "Life Support"
	desc = "The disease provides the essential nutrition and oxygenation necessary for the host's survival when critically injured, stabilizing them indefinitely."
	id = "symptom_life_support"
	property_type = /datum/disease_property/symptom/life_support

/datum/design/virology/property/symptom/temporal_flux
	name = "Temporal Flux"
	desc = "The disease uses exotic matter to store and release time in a regular cycle, alternately speeding up and slowing the host."
	id = "symptom_temporal_flux"
	property_type = /datum/disease_property/symptom/temporal_flux

/datum/design/virology/property/symptom/ocular_regrowth
	name = "Ocular Regrowth"
	desc = "The disease stimulates the production and replacement of sensory tissues, causing the host to regenerate their eyes if damaged."
	id = "symptom_ocular_regrowth"
	property_type = /datum/disease_property/symptom/ocular_regrowth

/datum/design/virology/property/symptom/visionloss
	name = "Hyphema"
	desc = "The disease causes inflammation of the retina, leading to eye damage and eventually blindness."
	id = "symptom_visionloss"
	property_type = /datum/disease_property/symptom/visionloss

/datum/design/virology/property/symptom/voice_change
	name = "Voice Change"
	desc = "The disease alters the pitch and tone of the host's vocal cords, changing how their voice sounds."
	id = "symptom_voice_change"
	property_type = /datum/disease_property/symptom/voice_change

/datum/design/virology/property/symptom/vomit
	name = "Vomiting"
	desc = "The disease causes nausea and irritates the stomach, causing occasional vomiting."
	id = "symptom_vomit"
	property_type = /datum/disease_property/symptom/vomit

///////////////////////////////////////////////////////////
////////////////////////////TRAITS/////////////////////////
///////////////////////////////////////////////////////////
/datum/design/virology/property/trait
	name = "Generic Trait"
	id = "default_disease_trait"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_trait"
	property_type = /datum/disease_property/trait

///////////////////////////////////////////////////////////
//////////////////////////PATHOGENS////////////////////////
///////////////////////////////////////////////////////////
/datum/design/virology/pathogen
	name = "Generic Pathogen"
	id = "default_pathogen"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_pathogen"
	var/pathogen_type = /datum/pathogen
