/*!
	Heats up the host's body.
*/

/datum/disease_property/symptom/fever
	name = "Fever"
	desc = "The disease causes a febrile response from the host, raising its body temperature."
	level = 2
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the heat threshold
	threshold_desc = "<b>ALPHA:</b> Increases fever intensity.<br>\
					  <b>BETA:</b> Increases fever intensity, fever can overheat and harm the host.<br>\
					  <b>EPSILON:</b> The disease causes extreme amount of heat, boling the host from the inside."

/datum/disease_property/symptom/fever/update_mutators()
	multiplier = 1
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_ALPHA))
		multiplier += 0.5
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_BETA))
		multiplier += 1
		unsafe = TRUE
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_EPSILON))
		multiplier += 10
		unsafe = TRUE

/datum/disease_property/symptom/fever/activate()
	var/mob/living/carbon/M = disease.affected_mob
	if(!unsafe || disease.stage < 4)
		to_chat(M, "<span class='warning'>[pick("You feel hot.", "You feel like you're burning.")]</span>")
	else
		to_chat(M, "<span class='warning'>[pick("You feel too hot.", "You feel like your blood is boiling.")]</span>")
	if((M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT) || unsafe)
		heat(M)

/datum/disease_property/symptom/fever/proc/heat(mob/living/M)
	var/get_heat = 6 * multiplier
	if(!unsafe)
		M.adjust_bodytemperature(get_heat * disease.stage, 0, BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
	else
		M.adjust_bodytemperature(get_heat * disease.stage)
