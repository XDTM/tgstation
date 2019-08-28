// Symptoms are the effects that engineered advanced diseases do.

/datum/disease_property/symptom
	var/threshold_desc = "" //Description of threshold effects
	// The severity level of the symptom. Higher is more dangerous.
	var/severity = 0
	//Seconds between each activation (checked every life tick)
	var/next_activation = 0
	var/symptom_delay_min = 1
	var/symptom_delay_max = 1

	//Handles cooldown between symptom feedback messages; randomized to avoid symptom messages all coming at once
	var/message_cooldown_min = 300
	var/message_cooldown_max = 700
	var/next_message = 0

	var/multiplier = 1 //Generic var to multiply virus effects, instead of making a new variable for each symptom
	var/list/thresholds

/// Adds the symptom to a disease.
/datum/disease_property/symptom/add_to(datum/disease/advance/A, overwrite)
	..()
	if(disease.symptoms.len < (disease.symptom_limit - 1))
		disease.symptoms += src
	else
		if(overwrite)
			disease.remove_property(pick(disease.symptoms))
			disease.symptoms += src
		else
			qdel(src)
			return

	on_add(disease)
	update_mutators()

/// Removes the symptom from a disease.
/datum/disease_property/symptom/remove()
	on_remove()
	disease.symptoms -= src
	..()

/// Applies mutator effects on the symptom
/datum/disease_property/symptom/proc/update_mutators()
	return

/// Called when processing of the advance disease, which holds this symptom, starts.
/datum/disease_property/symptom/on_start()
	next_activation = world.time + rand(symptom_delay_min * 10, symptom_delay_max * 10) //so it doesn't instantly activate on infection

// Called when the advance disease is going to be deleted or when the advance disease stops processing.
/datum/disease_property/symptom/on_end()
	return

/datum/disease_property/symptom/on_process()
	if(world.time < next_activation)
		return
	else
		next_activation = world.time + rand(symptom_delay_min * 10, symptom_delay_max * 10)
		activate()

/// Activates the symptom, called every rand(symptom_delay_min, symptom_delay_max) seconds
/datum/disease_property/symptom/proc/activate()
	return

/datum/disease_property/symptom/proc/message_cooldown()
	if(world.time < next_message)
		return FALSE
	else
		next_message = world.time + rand(message_cooldown_min, message_cooldown_max)
		return TRUE

/datum/disease_property/symptom/proc/generate_threshold_desc()
	return
