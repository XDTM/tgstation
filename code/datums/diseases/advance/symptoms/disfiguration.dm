/*
//////////////////////////////////////
Disfiguration

	Hidden.
	No change to resistance.
	Increases stage speed.
	Slightly increases transmittability.
	Critical Level.

BONUS
	Adds disfiguration trait making the mob appear as "Unknown" to others.

//////////////////////////////////////
*/

/datum/disease_property/symptom/disfiguration
	name = "Facial Contortion"
	desc = "The disease causes the host's facial muscles to contract in unnatural shapes, distorting their features to the point of being unrecognizable."
	symptom_delay_min = 25
	symptom_delay_max = 75

/datum/disease_property/symptom/disfiguration/activate()
	var/mob/living/M = disease.affected_mob
	if (HAS_TRAIT_FROM(M, TRAIT_DISFIGURED, DISEASE_TRAIT))
		return
	switch(disease.stage)
		if(5)
			ADD_TRAIT(M, TRAIT_DISFIGURED, DISEASE_TRAIT)
			M.visible_message("<span class='warning'>[M]'s face contorts in an unrecognizable inhumane grimace!</span>", "<span class='warning'>You feel your face spasm, locking you into a painful grimace!</span>")
		else
			M.visible_message("<span class='warning'>[M]'s face begins to contort...</span>", "<span class='warning'>You feel your facial muscles pulling on their own...</span>")


/datum/disease_property/symptom/disfiguration/passive_effect_end()
	var/mob/living/M = disease.affected_mob
	REMOVE_TRAIT(M, TRAIT_DISFIGURED, DISEASE_TRAIT)
	M.visible_message("<span class='warning'>[M]'s contorted face relaxes and returns to their original shape!</span>", "<span class='notice'>You feel your contorted face finally relax and return to normal.</span>")
