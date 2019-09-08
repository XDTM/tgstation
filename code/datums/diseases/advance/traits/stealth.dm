/datum/disease_property/trait/stealth_hud
	name = "Mimetic Enzymes"
	desc = "The disease mimics body cells when analyzed superficially, making it invisible to medical HUDs."
	resistance = -1
	speed = -1
	infectivity = -1

/datum/disease_property/trait/stealth_hud/on_add()
	..()
	ADD_TRAIT(disease, DISEASE_HIDDEN_HUD, type)

/datum/disease_property/trait/stealth_hud/on_remove()
	REMOVE_TRAIT(disease, DISEASE_HIDDEN_SCANNER, type)
	..()

/datum/disease_property/trait/stealth_scan
	name = "Metabolic Mirroring"
	desc = "Makes the disease invisible to medical analysis by closely mirroring the host's metabolic functions. Reduces disease stats due to the loss of efficiency."
	resistance = -3
	speed = -3
	infectivity = -3

/datum/disease_property/trait/stealth_scan/on_add()
	..()
	ADD_TRAIT(disease, DISEASE_HIDDEN_HUD, type)
	ADD_TRAIT(disease, DISEASE_HIDDEN_SCANNER, type)

/datum/disease_property/trait/stealth_scan/on_remove()
	REMOVE_TRAIT(disease, DISEASE_HIDDEN_HUD, type)
	REMOVE_TRAIT(disease, DISEASE_HIDDEN_SCANNER, type)
	..()
