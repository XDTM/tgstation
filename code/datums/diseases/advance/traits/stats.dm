/datum/disease_property/trait/all_stats
	name = "Selective Genes"
	desc = "The disease performs artificial selection when reproducing, keeping only the better pathogens. Increases all stats by 1."
	class = DISEASE_CLASS_STATS
	resistance = 1
	speed = 1
	infectivity = 1

/datum/disease_property/trait/resistance
	name = "Internal Membrane"
	desc = "The disease has an additional internal membrane, increasing the resistance of the disease by 2."
	class = DISEASE_CLASS_STATS
	resistance = 2

/datum/disease_property/trait/resistance_for_speed
	name = "Outer Shell"
	desc = "The disease has an impermeable external shell, increasing the resistance of the disease by 4, but slowing down its speed by 2."
	class = DISEASE_CLASS_STATS
	resistance = 4
	speed = -2

/datum/disease_property/trait/resistance_for_infectivity
	name = "Fuzzy Membrane"
	desc = "The disease has a fuzzy external membrane, increasing the resistance of the disease by 4, but reducing its infectivity by 2."
	class = DISEASE_CLASS_STATS
	resistance = 4
	infectivity = -2

/datum/disease_property/trait/speed
	name = "Efficient Metabolism"
	desc = "The disease has a more efficient metabolic process, increasing the speed of the disease by 2."
	class = DISEASE_CLASS_STATS
	speed = 2

/datum/disease_property/trait/speed_for_resistance
	name = "Porous Membrane"
	desc = "The disease has a porous membrane, increasing the speed of the disease by 4, but reducing its resistance by 2."
	class = DISEASE_CLASS_STATS
	speed = 4
	resistance = -2

/datum/disease_property/trait/speed_for_infectivity
	name = "Amorphous Shape"
	desc = "The disease has an amorphous shape, increasing the speed of the disease by 4, but reducing its infectivity by 2."
	class = DISEASE_CLASS_STATS
	speed = 4
	infectivity = -2
	
/datum/disease_property/trait/infectivity
	name = "Motile Cilia"
	desc = "The disease has external motile cilia, increasing the infectivity of the disease by 2."
	class = DISEASE_CLASS_STATS
	infectivity = 2

/datum/disease_property/trait/infectivity_for_resistance
	name = "Barbed Membrane"
	desc = "The disease has a barbed membrane, increasing the infectivity of the disease by 4, but reducing its resistance by 2."
	class = DISEASE_CLASS_STATS
	infectivity = 4
	resistance = -2

/datum/disease_property/trait/infectivity_for_speed
	name = "Suction Tendrils"
	desc = "The disease has several suction terndrils, increasing the infectivity of the disease by 4, but reducing its speed by 2."
	class = DISEASE_CLASS_STATS
	infectivity = 4
	speed = -2
