/*!Causes a constant buildup of sleepiness, which results in an increasing chance of falling asleep on the spot when the symptom activates.
Sleepiness only decreases when asleep, and won't simply reset when the sleep triggers; therefore, trying to "skip" the sleep by getting shaken awake or by drinking coffee
will also result in falling asleep more often and for longer.
*/
/datum/disease_property/symptom/narcolepsy
	name = "Narcolepsy"
	desc = "The virus causes a hormone imbalance, making the host sleepy and narcoleptic."
	symptom_delay_min = 60
	symptom_delay_max = 120
	var/sleepiness = 0
	var/rapid_sleep = FALSE
	threshold_desc = "<b>GAMMA:</b> Additionally causes brief episodes of unconsciousness."

/datum/disease_property/symptom/narcolepsy/update_mutators()
	if(HAS_TRAIT(disease,DISEASE_MUTATOR_GAMMA))
		rapid_sleep = TRUE
	else
		rapid_sleep = FALSE

/datum/disease_property/symptom/narcolepsy/on_process()
	..()
	if(disease.stage < 5)
		return
	var/mob/living/M = disease.affected_mob
	if(M.IsSleeping())
		sleepiness = max(sleepiness - 5, 0)
	else
		sleepiness = min(sleepiness + 1, 120)

/datum/disease_property/symptom/narcolepsy/activate()
	var/mob/living/M = disease.affected_mob
	if(HAS_TRAIT(M, TRAIT_SLEEPIMMUNE))
		return
	if(disease.stage < 5)
		if(disease.stage > 2 && message_cooldown())
			to_chat(M, "<span class='warning'>[pick("You feel tired.","You feel sleepy.","You have a hard time keeping your eyes open.","You try to stay awake.")]</span>")
		return
	if(prob(sleepiness))
		fall_asleep(M)
	else
		if(rapid_sleep)
			to_chat(M, "<span class='warning'>[pick("You black out for a moment.","You nod off for a second.")]</span>")
			M.Sleeping(20)
		else
			to_chat(M, "<span class='warning'>[pick("So tired...","You feel very sleepy.","You have a hard time keeping your eyes open.","You try to stay awake.")]</span>")
			M.drowsyness += (sleepiness * 0.2)

///The mob falls asleep after 5 seconds of the warning, for a duration based on the sleepiness counter.
/datum/disease_property/symptom/narcolepsy/proc/fall_asleep(mob/living/M)
	to_chat(M, "<span class='warning'>[pick("Your vision starts fading to black...","You can't stay awake anymore...")]</span>")
	M.drowsyness += 5
	addtimer(CALLBACK(M, .proc/Sleeping, sleepiness * 10), 50)




