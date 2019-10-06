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
