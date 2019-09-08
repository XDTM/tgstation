/datum/disease_property/symptom/nano_boost
	name = "Nano-symbiosis"
	desc = "The disease reacts to nanites in the host's bloodstream by enhancing their replication cycle."

/datum/disease_property/symptom/nano_boost/on_process()
	..()
	var/mob/living/carbon/M = disease.affected_mob
	SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, 0.5 * multiplier)

/datum/disease_property/symptom/nano_destroy
	name = "Silicolysis"
	desc = "The disease reacts to nanites in the host's bloodstream by attacking and consuming them."

/datum/disease_property/symptom/nano_destroy/on_process()
	..()
	var/mob/living/carbon/M = disease.affected_mob
	SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, -0.4 * multiplier)
