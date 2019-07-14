/datum/disease_property/trait

/// Adds the trait to a disease.
/datum/disease_property/trait/add_to(datum/disease/advance/A)
	..()
	disease.traits += src
	on_add(disease)

/// Removes the symptom from a disease.
/datum/disease_property/trait/remove()
	on_remove()
	disease.disease_traits -= src
	..()
