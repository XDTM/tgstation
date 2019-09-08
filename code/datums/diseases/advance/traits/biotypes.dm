/datum/disease_property/trait/undead_adaptation
	name = "Necrotic Metabolism"
	desc = "The disease is able to thrive and act even within dead hosts."

/datum/disease_property/trait/undead_adaptation/on_add()
	ADD_TRAIT(disease, DISEASE_PROCESS_DEAD, type)
	disease.infectable_biotypes |= MOB_UNDEAD

/datum/disease_property/trait/undead_adaptation/on_remove()
	REMOVE_TRAIT(disease, DISEASE_PROCESS_DEAD, type)
	disease.infectable_biotypes &= ~MOB_UNDEAD

/datum/disease_property/trait/inorganic_adaptation
	name = "Inorganic Biology"
	desc = "The disease can survive and replicate even in an inorganic environment."

/datum/disease_property/trait/inorganic_adaptation/on_add()
	disease.infectable_biotypes |= MOB_MINERAL

/datum/disease_property/trait/inorganic_adaptation/on_remove()
	disease.infectable_biotypes &= ~MOB_MINERAL
