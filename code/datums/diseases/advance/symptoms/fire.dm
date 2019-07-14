/*!
	Periodically ignites infected mob.
*/
/datum/disease_property/symptom/fire
	name = "Spontaneous Combustion"
	desc = "The virus turns fat into an extremely flammable compound, and raises the body's temperature, making the host burst into flames spontaneously."
	level = 6
	symptom_delay_min = 20
	symptom_delay_max = 75
	var/infective = FALSE
	var/explosive = FALSE
	var/next_explosion = 0
	threshold_desc = "<b>BETA:</b> Host will spread the virus through skin flakes when bursting into flame.<br>\
					  <b>GAMMA:</b> Increases the intensity of the flames.<br>\
					  <b>DELTA:</b> Host will cause an explosive reaction when in contact with water."

/datum/disease_property/symptom/fire/update_mutators()
	if(disease.mutators[DISEASE_MUTATOR_BETA])
		infective = TRUE
	else
		infective = FALSE
	if(disease.mutators[DISEASE_MUTATOR_GAMMA])
		multiplier = 2
	else
		multiplier = 1
	if(disease.mutators[DISEASE_MUTATOR_DELTA])
		explosive = TRUE
	else
		explosive = FALSE

/datum/disease_property/symptom/fire/activate()
	var/mob/living/M = disease.affected_mob
	switch(disease.stage)
		if(3)
			if(message_cooldown())
				to_chat(M, "<span class='warning'>[pick("You feel hot.", "You feel like you're burning.")]</span>")
		if(4)
			firestacks_minor(M)
			M.IgniteMob()
			to_chat(M, "<span class='userdanger'>Your skin bursts into flames!</span>")
			M.emote("scream")
		if(5)
			firestacks(M)
			M.IgniteMob()
			to_chat(M, "<span class='userdanger'>Your skin erupts into an inferno!</span>")
			M.emote("scream")

/datum/disease_property/symptom/fire/on_process()
	..()
	if(M.fire_stacks < -1 && explosive && (next_explosion > world.time))
		M.visible_message("<span class='warning'>[M]'s sweat detonates on contact with water!</span>")
		M.fire_stacks = 0
		explosion(get_turf(M),0,0,2 * explosion_power)
		next_explosion = world.time + 200

/datum/disease_property/symptom/fire/proc/firestacks_minor(mob/living/M)
	M.adjust_fire_stacks(1 * multiplier)
	M.take_overall_damage(burn = 3 * multiplier, required_status = BODYPART_ORGANIC)
	if(infective)
		A.airborne_spread(2, DISEASE_SPREAD_CONTACT_SKIN)

/datum/disease_property/symptom/fire/proc/firestacks(mob/living/M)
	M.adjust_fire_stacks(3 * multiplier)
	M.take_overall_damage(burn = 5 * multiplier, required_status = BODYPART_ORGANIC)
	if(infective)
		A.airborne_spread(4, DISEASE_SPREAD_CONTACT_SKIN)
