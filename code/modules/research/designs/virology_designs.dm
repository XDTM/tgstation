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

/datum/design/virology/property/trait/undead_adaptation
	name = "Necrotic Metabolism"
	desc = "The disease is able to thrive and act even within dead hosts."
	id = "disease_trait_undead_adaptation"
	property_type = /datum/disease_property/trait/undead_adaptation

/datum/design/virology/property/trait/inorganic_adaptation
	name = "Inorganic Biology"
	desc = "The disease can survive and replicate even in an inorganic environment."
	id = "disease_trait_inorganic_adaptation"
	property_type = /datum/disease_property/trait/inorganic_adaptation

/datum/design/virology/property/trait/immolation
	name = "Immolation"
	desc = "The disease accelerates its metabolism to the point of self-destruction, increasing its stats but causing it to burn out \
	and cure itself some time after the final stage. Faster diseases are quicker to burn out."
	id = "disease_trait_immolation"
	property_type = /datum/disease_property/trait/immolation

/datum/design/virology/property/trait/mutator_alpha
	name = "Alpha Strain"
	desc = "The disease has an additional segment of DNA which enhances some symptoms."
	id = "disease_trait_mutator_alpha"
	property_type = /datum/disease_property/trait/mutator_alpha

/datum/design/virology/property/trait/mutator_beta
	name = "Beta Sequence"
	desc = "The disease has a parallel sequence of DNA which causes symptoms to have additional effects."
	id = "disease_trait_mutator_beta"
	property_type = /datum/disease_property/trait/mutator_beta

/datum/design/virology/property/trait/mutator_gamma
	name = "Gamma Ribosomes"
	desc = "The disease has specialized ribosomes who can read DNA in multiple configurations, evolving some symptoms."
	id = "disease_trait_mutator_gamma"
	property_type = /datum/disease_property/trait/mutator_gamma

/datum/design/virology/property/trait/mutator_delta
	name = "Delta Plane"
	desc = "The disease has an advanced two-dimensional planar DNA, containing the multitude of instructions needed for very complex symptom effects."
	id = "disease_trait_mutator_delta"
	property_type = /datum/disease_property/trait/mutator_delta

/datum/design/virology/property/trait/mutator_epsilon
	name = "Epsilon Cell"
	desc = "The disease hosts a mutable sub-disease, allowing it to specialize for different tasks when reproducing, therefore enabling far more powerful symptom effects. \
	However, the cost of hosting and replicating the cell reduces its speed significantly, as well as reducing resistance and infectivity."
	id = "disease_trait_mutator_epsilon"
	property_type = /datum/disease_property/trait/mutator_epsilon

/datum/design/virology/property/trait/mutator_omega
	name = "Omega Nucleus"
	desc = "The disease replaces its DNA with an extremely advanced molecule, able to intelligently transform itself into a variety of configurations. \
	The disease is less efficient because of this, but it simultaneously holds the effects of mutators from Alpha to Delta."
	id = "disease_trait_mutator_omega"
	property_type = /datum/disease_property/trait/mutator_omega

/datum/design/virology/property/trait/mutator_theta
	name = "Theta Core"
	desc = "The disease additionally grows a nodule of exotic matter, changing the effect of some symptoms in anomalous ways."
	id = "disease_trait_mutator_theta"
	property_type = /datum/disease_property/trait/mutator_theta

/datum/design/virology/property/trait/fluid_spreading
	name = "Fluid Infection"
	desc = "The disease can survive inside blood and body fluids and infect new hosts on contact."
	id = "disease_trait_fluid_spreading"
	property_type = /datum/disease_property/trait/fluid_spreading

/datum/design/virology/property/trait/contact_spreading
	name = "Contact Infection"
	desc = "The disease can infect others through brief skin-to-skin contact."
	id = "disease_trait_contact_spreading"
	property_type = /datum/disease_property/trait/contact_spreading

/datum/design/virology/property/trait/airborne_spreading
	name = "Airborne Infection"
	desc = "The disease can survive briefly in open air, and infect others who breathe it."
	id = "disease_trait_airborne_spreading"
	property_type = /datum/disease_property/trait/airborne_spreading

/datum/design/virology/property/trait/all_stats
	name = "Selective Genes"
	desc = "The disease performs artificial selection when reproducing, keeping only the better pathogens. Increases all stats by 1."
	id = "disease_trait_all_stats"
	property_type = /datum/disease_property/trait/all_stats

/datum/design/virology/property/trait/resistance
	name = "Internal Membrane"
	desc = "The disease has an additional internal membrane, increasing the resistance of the disease by 2."
	id = "disease_trait_resistance"
	property_type = /datum/disease_property/trait/resistance

/datum/design/virology/property/trait/resistance_for_speed
	name = "Outer Shell"
	desc = "The disease has an impermeable external shell, increasing the resistance of the disease by 4, but slowing down its speed by 2."
	id = "disease_trait_resistance_for_speed"
	property_type = /datum/disease_property/trait/resistance_for_speed

/datum/design/virology/property/trait/resistance_for_infectivity
	name = "Fuzzy Membrane"
	desc = "The disease has a fuzzy external membrane, increasing the resistance of the disease by 4, but reducing its infectivity by 2."
	id = "disease_trait_resistance_for_infectivity"
	property_type = /datum/disease_property/trait/resistance_for_infectivity

/datum/design/virology/property/trait/speed
	name = "Efficient Metabolism"
	desc = "The disease has a more efficient metabolic process, increasing the speed of the disease by 2."
	id = "disease_trait_speed"
	property_type = /datum/disease_property/trait/speed

/datum/design/virology/property/trait/speed_for_resistance
	name = "Porous Membrane"
	desc = "The disease has a porous membrane, increasing the speed of the disease by 4, but reducing its resistance by 2."
	id = "disease_trait_speed_for_resistance"
	property_type = /datum/disease_property/trait/speed_for_resistance

/datum/design/virology/property/trait/speed_for_infectivity
	name = "Amorphous Shape"
	desc = "The disease has an amorphous shape, increasing the speed of the disease by 4, but reducing its infectivity by 2."
	id = "disease_trait_speed_for_infectivity"
	property_type = /datum/disease_property/trait/speed_for_infectivity

/datum/design/virology/property/trait/infectivity
	name = "Motile Cilia"
	desc = "The disease has external motile cilia, increasing the infectivity of the disease by 2."
	id = "disease_trait_infectivity"
	property_type = /datum/disease_property/trait/infectivity

/datum/design/virology/property/trait/infectivity_for_resistance
	name = "Barbed Membrane"
	desc = "The disease has a barbed membrane, increasing the infectivity of the disease by 4, but reducing its resistance by 2."
	id = "disease_trait_infectivity_for_resistance"
	property_type = /datum/disease_property/trait/infectivity_for_resistance

/datum/design/virology/property/trait/infectivity_for_speed
	name = "Suction Tendrils"
	desc = "The disease has several suction terndrils, increasing the infectivity of the disease by 4, but reducing its speed by 2."
	id = "disease_trait_infectivity_for_speed"
	property_type = /datum/disease_property/trait/infectivity_for_speed

/datum/design/virology/property/trait/stealth_hud
	name = "Mimetic Enzymes"
	desc = "The disease mimics body cells when analyzed superficially, making it invisible to medical HUDs."
	id = "disease_trait_stealth_hud"
	property_type = /datum/disease_property/trait/stealth_hud

/datum/design/virology/property/trait/stealth_scan
	name = "Metabolic Mirroring"
	desc = "Makes the disease invisible to medical analysis by closely mirroring the host's metabolic functions. Reduces disease stats due to the loss of efficiency."
	id = "disease_trait_stealth_scan"
	property_type = /datum/disease_property/trait/stealth_scan

///////////////////////////////////////////////////////////
//////////////////////////PATHOGENS////////////////////////
///////////////////////////////////////////////////////////
/datum/design/virology/pathogen
	name = "Generic Pathogen"
	id = "default_pathogen"
	research_icon = 'icons/obj/device.dmi'
	research_icon_state = "disease_pathogen"
	var/pathogen_type = /datum/pathogen

/datum/design/virology/pathogen/ab_murion
	name = "AB Murion"
	desc = "The current intergalactic standard for disease research, striking a good balance between core and membrane. Recommended by 9 virologists out of 10."
	id = "pathogen_ab_murion"
	var/pathogen_type = /datum/pathogen/ab_murion

/datum/design/virology/pathogen/zy_murion
	name = "ZY Murion"
	desc = "A variant of the AB Murion, mutated to spread by skin contact instead of fluids."
	id = "pathogen_zy_murion"
	var/pathogen_type = /datum/pathogen/zy_murion

/datum/design/virology/pathogen/csal_41
	name = "CSAL-41"
	desc = "A pathogen blueprint resulting from bio-miniaturization research. There is less space to work with, but the reduced size has significant benefits in efficiency and infectivity."
	id = "pathogen_csal_41"
	var/pathogen_type = /datum/pathogen/csal_41

/datum/design/virology/pathogen/csal_42
	name = "CSAL-42"
	desc = "A modern variant of CSAL-41, this pathogen offers a compromise between miniaturization and capacity."
	id = "pathogen_csal_42"
	var/pathogen_type = /datum/pathogen/csal_42

/datum/design/virology/pathogen/mono_gtr
	name = "Mono-GTR"
	desc = "A pathogen consisting of a specialized core surrounded by several layers of support structures. It was initially used to spread vaccinations to livestock."
	id = "pathogen_mono_gtr"
	var/pathogen_type = /datum/pathogen/mono_gtr

/datum/design/virology/pathogen/mono_pwr
	name = "Mono-PWR"
	desc = "A variant of Mono-GTR geared towards maximizing efficiency instead of support structures."
	id = "pathogen_mono_pwr"
	var/pathogen_type = /datum/pathogen/mono_pwr

/datum/design/virology/pathogen/duke_h
	name = "DUKE.h"
	desc = "A pathogen designed to be the noble gas equivalent of virology. It has no natural spread mechanism, preventing unintentional outbreaks. \
	However, these safety features take a heavy toll on the disease's growth speed."
	id = "pathogen_duke_h"
	var/pathogen_type = /datum/pathogen/duke_h

/datum/design/virology/pathogen/count_d
	name = "COUNT.d"
	desc = "A variant of the more common DUKE.h, this pathogen prevents infection even through blood contact by synchronizing to their host's metabolism. The disease needs to be administered \
	from the original sample to work."
	id = "pathogen_count_d"
	var/pathogen_type = /datum/pathogen/count_d

/datum/design/virology/pathogen/large_8
	name = "LARGE-8"
	desc = "A pathogen with an uncommon design, placing the support structures at the center and its multiple cores in an octagonal pattern around it."
	id = "pathogen_large_8"
	var/pathogen_type = /datum/pathogen/large_8

/datum/design/virology/pathogen/huge_16
	name = "HUGE-16"
	desc = "A variation of LARGE-8, this massive pathogen has an extreme amount of space for both cores and support structures, but suffers greatly in terms of base efficiency."
	id = "pathogen_huge_16"
	var/pathogen_type = /datum/pathogen/huge_16

/datum/design/virology/pathogen/dawn
	name = "Dawn"
	desc = "The result of the infamous project Dawn: a variation of the AB Murion which is nearly undetectable by medical scans, while being more efficient at the same time. \
	Its use was heavily restricted after several outbreaks from research institutes proved nearly impossible to eradicate."
	id = "pathogen_dawn"
	var/pathogen_type = /datum/pathogen/dawn

/datum/design/virology/pathogen/dusk
	name = "Dusk"
	desc = "An illegal revisitation of the Dawn project, resulting in an even more dangerous pathogen."
	id = "pathogen_dusk"
	var/pathogen_type = /datum/pathogen/dusk

/datum/design/virology/pathogen/midnight
	name = "Midnight"
	desc = "\[REDACTED\]"
	id = "pathogen_ab_murion"
	var/pathogen_type = /datum/pathogen/midnight

/datum/design/virology/pathogen/syn_dr_111
	name = "SYN:Dr_111"
	desc = "Developed by an unnamed syndicate doctor, this pathogen has severely interdependent mechanisms which limit its cusomizability, but give it a spectacular boost in efficiency."
	id = "pathogen_syn_dr_111"
	var/pathogen_type = /datum/pathogen/syn_dr_111

/datum/design/virology/pathogen/syn_dr_0m3
	name = "SYN:Dr_0M3"
	desc = "A modification of SYN:DR_111 geared towards mutators instead of pure efficiency."
	id = "pathogen_syn_dr_0m3"
	var/pathogen_type = /datum/pathogen/syn_dr_0m3

/datum/design/virology/pathogen/grey
	name = "GREY"
	desc = "Reverse-engineered from abductor biotechnology, this pathogen is extremely infective, while still having a high core capacity."
	id = "pathogen_grey"
	var/pathogen_type = /datum/pathogen/grey

/datum/design/virology/pathogen/black
	name = "BLACK"
	desc = "Perfection made pathogen."
	id = "pathogen_black"
	var/pathogen_type = /datum/pathogen/black
