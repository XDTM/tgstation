/datum/disease_property/trait/mutator_alpha
	name = "Alpha Strain"
	desc = "The disease has an additional segment of DNA which enhances some symptoms."

/datum/disease_property/trait/mutator_alpha/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_ALPHA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_alpha/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_ALPHA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_beta
	name = "Beta Sequence"
	desc = "The disease has a parallel sequence of DNA which causes symptoms to have additional effects."

/datum/disease_property/trait/mutator_beta/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_BETA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_alpha/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_BETA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_gamma
	name = "Gamma Ribosomes"
	desc = "The disease has specialized ribosomes who can read DNA in multiple configurations, evolving some symptoms."

/datum/disease_property/trait/mutator_gamma/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_GAMMA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_gamma/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_GAMMA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_delta
	name = "Delta Plane"
	desc = "The disease has an advanced two-dimensional planar DNA, containing the multitude of instructions needed for very complex symptom effects."

/datum/disease_property/trait/mutator_delta/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_DELTA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_delta/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_DELTA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_epsilon
	name = "Epsilon Cell"
	desc = "The disease hosts a mutable sub-disease, allowing it to specialize for different tasks when reproducing, therefore enabling far more powerful symptom effects. \
	However, the cost of hosting and replicating the cell reduces its speed significantly, as well as reducing resistance and infectivity."
	resistance = -2
	speed = -6
	infectivity = -2

/datum/disease_property/trait/mutator_epsilon/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_EPSILON, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_epsilon/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_EPSILON, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_omega
	name = "Omega Nucleus"
	desc = "The disease replaces its DNA with an extremely advanced molecule, able to intelligently transform itself into a variety of configurations. \
	The disease is less efficient because of this, but it simultaneously holds the effects of mutators from Alpha to Delta."
	resistance = -2
	speed = -2
	infectivity = -2

/datum/disease_property/trait/mutator_omega/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_ALPHA, type)
	ADD_TRAIT(disease, DISEASE_MUTATOR_BETA, type)
	ADD_TRAIT(disease, DISEASE_MUTATOR_GAMMA, type)
	ADD_TRAIT(disease, DISEASE_MUTATOR_DELTA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_omega/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_EPSILON, type)
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_BETA, type)
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_GAMMA, type)
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_DELTA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_theta
	name = "Theta Core"
	desc = "The disease additionally grows a nodule of exotic matter, changing the effect of some symptoms in anomalous ways."

/datum/disease_property/trait/mutator_theta/on_add()
	ADD_TRAIT(disease, DISEASE_MUTATOR_THETA, type)
	disease.update_mutators()

/datum/disease_property/trait/mutator_theta/on_remove()
	REMOVE_TRAIT(disease, DISEASE_MUTATOR_THETA, type)
	disease.update_mutators()
