/datum/disease_property/trait/fluid_spreading
	name = "Fluid Infection"
	desc = "The disease can survive inside blood and body fluids and infect new hosts on contact."

/datum/disease_property/trait/fluid_spreading/on_add()
	..()
	ADD_TRAIT(disease, DISEASE_SPREAD_CONTACT_FLUIDS, type)

/datum/disease_property/trait/fluid_spreading/on_remove()
	REMOVE_TRAIT(disease, DISEASE_SPREAD_CONTACT_FLUIDS, type)
	..()

/datum/disease_property/trait/contact_spreading
	name = "Contact Infection"
	desc = "The disease can infect others through brief skin-to-skin contact."

/datum/disease_property/trait/contact_spreading/on_add()
	..()
	ADD_TRAIT(disease, DISEASE_SPREAD_CONTACT_SKIN, type)

/datum/disease_property/trait/contact_spreading/on_remove()
	REMOVE_TRAIT(disease, DISEASE_SPREAD_CONTACT_SKIN, type)
	..()

/datum/disease_property/trait/airborne_spreading
	name = "Airborne Infection"
	desc = "The disease can survive briefly in open air, and infect others who breathe it."

/datum/disease_property/trait/airborne_spreading/on_add()
	..()
	ADD_TRAIT(disease, DISEASE_SPREAD_AIRBORNE, type)

/datum/disease_property/trait/airborne_spreading/on_remove()
	REMOVE_TRAIT(disease, DISEASE_SPREAD_AIRBORNE, type)
	..()

/datum/disease_property/trait/bluespace_spreading
	name = "Bluespace Infection"
	desc = "The disease constantly teleports a portion of its pathogens randomly around the host, potentially infecting nearby targets through any protection. \
	Takes a severe toll on the disease's speed as a result."
	speed = -5

/datum/disease_property/trait/bluespace_spreading/on_process()
	..()
	if(prob(10))
		for(var/mob/living/carbon/C in range(4, disease.affected_mob))
			C.ForceContractDisease(disease)
			return //only one

