/datum/disease_property/symptom/trauma
	name = "Generic Trauma"
	desc = "The disease causes a specific brain trauma."
	symptom_delay_min = 45
	symptom_delay_max = 90
	var/severe = FALSE
	threshold_desc = "<b>DELTA:</b> Makes the trauma more severe, requiring surgical treatment to be cured even if the disease is eradicated."
	var/trauma_type

/datum/disease_property/symptom/trauma/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_DELTA))
		severe = TRUE
	else
		severe = FALSE

/datum/disease_property/symptom/trauma/activate()
	var/mob/living/carbon/M = disease.affected_mob
	var/severity = severe ? TRAUMA_RESILIENCE_SURGERY : TRAUMA_RESILIENCE_BASIC
	if(disease.stage == 5 && !M.has_trauma_type(trauma_type, severity))
		M.gain_trauma(trauma_type, severity)

/datum/disease_property/symptom/trauma/on_end()
	M.cure_trauma_type(trauma_type, TRAUMA_RESILIENCE_BASIC) //No need to check for severe, if the mutator is active it will be above the cure threshold

/datum/disease_property/symptom/trauma/healthy
	name = "Anosognosia"
	desc = "The disease affects the patient's brain, making them unable to notice pain or wounds."
	trauma_type = /datum/brain_trauma/mild/healthy

/datum/disease_property/symptom/trauma/speech_impediment
	name = "Speech Impediment"
	desc = "The disease affects the patient's brain, making them unable to form coherent sentences."
	trauma_type = /datum/brain_trauma/mild/speech_impediment

/datum/disease_property/symptom/trauma/muscle_weakness
	name = "Muscle Weakness"
	desc = "The disease affects the patient's brain, causing occasional bouts of muscle weakness."
	trauma_type = /datum/brain_trauma/mild/muscle_weakness

/datum/disease_property/symptom/trauma/muscle_spasms
	name = "Muscle Spasms"
	desc = "The disease affects the patient's brain, causing occasional muscle spasms."
	trauma_type = /datum/brain_trauma/mild/muscle_spasms

/datum/disease_property/symptom/trauma/mute
	name = "Mutism"
	desc = "The disease affects the patient's brain, making them completely unable to speak."
	trauma_type = /datum/brain_trauma/severe/mute

/datum/disease_property/symptom/trauma/blindness
	name = "Cerebral Blindness"
	desc = "The disease affects the patient's brain, making them unable to see."
	trauma_type = /datum/brain_trauma/severe/blindness

/datum/disease_property/symptom/trauma/paralysis
	name = "Paralysis"
	desc = "The disease affects the patient's brain, causing paralysis of one or multiple limbs."
	trauma_type = /datum/brain_trauma/severe/paralysis

/datum/disease_property/symptom/trauma/pacifism
	name = "Pacifism"
	desc = "The disease affects the patient's brain, suppressing violent tendencies."
	trauma_type = /datum/brain_trauma/severe/pacifism

/datum/disease_property/symptom/trauma/phobia
	name = "Phobia"
	desc = "The disease affects the patient's brain, causing irrational fears."
	trauma_type = /datum/brain_trauma/mild/phobia
