/datum/disease_property/symptom/genetic_mutation
	name = "DNA Mutation"
	desc = "The disease bonds with the DNA of the host, causing random mutations until removed."
	var/list/possible_mutations
	var/archived_dna = null
	symptom_delay_min = 60
	symptom_delay_max = 120
	var/no_reset = FALSE
	threshold_desc = "<b>BETA:</b> The mutations persist even if the disease is cured."

/datum/disease_property/symptom/genetic_mutation/activate()
	var/mob/living/carbon/C = disease.affected_mob
	if(!C.has_dna())
		return
	switch(disease.stage)
		if(4, 5)
			to_chat(C, "<span class='warning'>[pick("Your skin feels itchy.", "You feel light headed.")]</span>")
			C.dna.remove_mutation_group(possible_mutations)
			C.randmut(possible_mutations)

/datum/disease_property/symptom/genetic_mutation/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		no_reset = TRUE
	else
		no_reset = FALSE

// Archive their DNA before they were infected.
/datum/disease_property/symptom/genetic_mutation/on_start()
	possible_mutations = (GLOB.bad_mutations | GLOB.not_good_mutations) - GLOB.all_mutations[RACEMUT]
	var/mob/living/carbon/M = disease.affected_mob
	if(M)
		if(!M.has_dna())
			return
		archived_dna = M.dna.mutation_index

// Give them back their old DNA when cured.
/datum/disease_property/symptom/genetic_mutation/on_end()
	if(!no_reset)
		var/mob/living/carbon/M = disease.affected_mob
		if(M && archived_dna)
			if(!M.has_dna())
				return
			M.dna.mutation_index = archived_dna
			M.domutcheck()
