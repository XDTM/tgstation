/datum/disease_property/symptom/resistance_infection
	name = "Rapid Adaptation"
	desc = "The disease can rapidly adapt to external conditions, increasing its resistance and infectivity at the cost of speed."
	resistance = 3
	speed = -3
	infectivity = 3
	class = DISEASE_CLASS_STATS

/datum/disease_property/symptom/resistance_speed
	name = "Synergetic Rooting"
	desc = "The disease specializes itself to life within its current host, increasing speed and resistance but reducing infectivity."
	resistance = 3
	speed = 3
	infectivity = -3
	class = DISEASE_CLASS_STATS

/datum/disease_property/symptom/infection_speed
	name = "Auto-Mitosis"
	desc = "The disease has a backup autonomous reproduction mechanism, increasing its speed and infectivity but reducing its resistance."
	resistance = -3
	speed = 3
	infectivity = 3
	class = DISEASE_CLASS_STATS
