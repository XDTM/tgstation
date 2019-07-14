/datum/disease_property/trait/undead_adaptation
	name = "Necrotic Metabolism"
	desc = "The virus is able to thrive and act even within dead hosts."

/datum/disease_property/trait/undead_adaptation/on_add()
	disease.process_dead = TRUE
	disease.infectable_biotypes |= MOB_UNDEAD

/datum/disease_property/trait/undead_adaptation/on_remove()
	disease.process_dead = FALSE
	disease.infectable_biotypes &= ~MOB_UNDEAD

/datum/disease_property/trait/inorganic_adaptation
	name = "Inorganic Biology"
	desc = "The virus can survive and replicate even in an inorganic environment, increasing its resistance and infection rate."

/datum/disease_property/trait/inorganic_adaptation/on_add()
	A.infectable_biotypes |= MOB_INORGANIC

/datum/disease_property/trait/inorganic_adaptation/on_remove()
	A.infectable_biotypes &= ~MOB_INORGANIC
