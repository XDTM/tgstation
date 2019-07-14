/datum/disease_property/trait/fluid_spreading
	name = "Fluid Infection"
	desc = "The disease can survive inside blood and body fluids and infect new hosts on contact."

/datum/disease_property/trait/fluid_spreading/on_add()
	..()
	disease.spread_flags |= DISEASE_SPREAD_CONTACT_FLUIDS

/datum/disease_property/trait/fluid_spreading/on_remove()
	disease.spread_flags &= ~DISEASE_SPREAD_CONTACT_FLUIDS
	..()

/datum/disease_property/trait/contact_spreading
	name = "Contact Infection"
	desc = "The disease can infect others through brief skin-to-skin contact."

/datum/disease_property/trait/contact_spreading/on_add()
	..()
	disease.spread_flags |= DISEASE_SPREAD_CONTACT_SKIN

/datum/disease_property/trait/contact_spreading/on_remove()
	disease.spread_flags &= ~DISEASE_SPREAD_CONTACT_SKIN
	..()

/datum/disease_property/trait/airborne_spreading
	name = "Airborne Infection"
	desc = "The disease can survive briefly in open air, and infect others who breath it."

/datum/disease_property/trait/airborne_spreading/on_add()
	..()
	disease.spread_flags |= DISEASE_SPREAD_AIRBORNE

/datum/disease_property/trait/airborne_spreading/on_remove()
	disease.spread_flags &= ~DISEASE_SPREAD_AIRBORNE
	..()
