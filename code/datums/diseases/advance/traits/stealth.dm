/datum/disease_property/trait/stealth_hud
	name = "Mimetic Enzymes"
	desc = "The disease is not visible on medical HUDs."

/datum/disease_property/trait/stealth_hud/on_add()
	..()
	disease.disease_flags |= HIDDEN_HUD

/datum/disease_property/trait/stealth_hud/on_remove()
	disease.disease_flags &= ~HIDDEN_HUD
	..()

/datum/disease_property/trait/stealth_scan
	name = "Metabolic Mirroring"
	desc = "The disease is not displayed on regular medical scans. Reduces disease stats."
	resistance = -1
	speed = -1
	infectivity = -1

/datum/disease_property/trait/stealth_scan/on_add()
	..()
	disease.disease_flags |= HIDDEN_SCANNER

/datum/disease_property/trait/stealth_scan/on_remove()
	disease.disease_flags &= ~HIDDEN_SCANNER
	..()
