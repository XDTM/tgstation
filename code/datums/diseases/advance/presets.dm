// Cold
/datum/disease/advance/cold
	copy_type = /datum/disease/advance

/datum/disease/advance/cold/New()
	name = "Cold"
	// symptoms = list(new/datum/disease_property/symptom/sneeze)
	..()

// Flu
/datum/disease/advance/flu
	copy_type = /datum/disease/advance

/datum/disease/advance/flu/New()
	name = "Flu"
	symptoms = list(new/datum/disease_property/symptom/cough)
	..()

//Randomly generated Disease, for virus crates and events
/datum/disease/advance/random
	name = "Experimental Disease"
	copy_type = /datum/disease/advance

/datum/disease/advance/random/New(max_symptoms, max_level = 8)
	if(!max_symptoms)
		max_symptoms = rand(1, VIRUS_SYMPTOM_LIMIT)
	var/list/datum/disease_property/symptom/possible_symptoms = list()
	for(var/symptom in subtypesof(/datum/disease_property/symptom))
		var/datum/disease_property/symptom/S = symptom
		if(initial(S.level) > max_level)
			continue
		if(initial(S.level) <= 0) //unobtainable symptoms
			continue
		possible_symptoms += S
	for(var/i in 1 to max_symptoms)
		var/datum/disease_property/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/disease_property/symptom/S = new chosen_symptom
			symptoms += S
	refresh()

	name = "Sample #[rand(1,10000)]"
