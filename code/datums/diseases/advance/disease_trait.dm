/datum/disease_property/trait

/// Adds the trait to a disease.
/datum/disease_property/trait/add_to(datum/disease/advance/A, overwrite)
	..()
	if(disease.disease_traits.len < (disease.pathogen.max_traits - 1))
		disease.disease_traits += src
	else
		if(overwrite)
			disease.remove_property(pick(disease.disease_traits))
			disease.disease_traits += src
		else
			qdel(src)
			return
			
	on_add(disease)
	disease.refresh()

	//If the disease is already active, bring it up to speed
	if(disease.processing)
		on_start()
		if(disease.stage > 1)
			for(var/i in 2 to disease.stage)
				on_stage_increase(i, i-1)	

/// Removes the symptom from a disease.
/datum/disease_property/trait/remove()
	if(disease.processing)
		on_end()
	on_remove()
	disease.disease_traits -= src
	..()
