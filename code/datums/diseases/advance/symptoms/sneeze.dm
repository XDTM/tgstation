/datum/disease_property/symptom/sneeze
	name = "Sneezing"
	desc = "The disease causes irritation of the nasal cavity, making the host sneeze occasionally, spreading the disease in a cone if airborne."
	symptom_delay_min = 5
	symptom_delay_max = 35
	var/fluid_spread = FALSE
	threshold_desc = "<b>ALPHA:</b> Increases sneezing range, spreading the disease over a larger area.<br>\
					  <b>BETA:</b> Makes the fluids expelled through sneezing thicker, carrying fluid-infecting diseases as well."

/datum/disease_property/symptom/sneeze/update_mutators()
	multiplier = 1
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_ALPHA))
		multiplier = 2
	if(HAS_TRAIT(disease, DISEASE_MUTATOR_BETA))
		fluid_spread = TRUE
	else
		fluid_spread = FALSE

/datum/disease_property/symptom/sneeze/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(1, 2, 3)
			M.emote("sniff")
		else
			M.emote("sneeze")
			if(M.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
				var/range = 2 * multiplier
				var/turf/T = M.loc
				if(istype(T))
					for(var/mob/living/target in oview(range, M))
						if(is_A_facing_B(M, target) && disease_air_spread_walk(get_turf(M), get_turf(target)))
							target.airborne_contract_disease(disease)
							if(fluid_spread && HAS_TRAIT(disease, DISEASE_SPREAD_CONTACT_FLUIDS))
								target.contact_contract_disease(disease, type = DISEASE_SPREAD_CONTACT_FLUIDS)
