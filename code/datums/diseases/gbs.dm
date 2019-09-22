/datum/disease/gbs
	name = "GBS"
	max_stages = 4
	cure_text = "Synaptizine & Sulfur"
	cures = list(/datum/reagent/medicine/synaptizine,/datum/reagent/sulfur)
	cure_chance = 15//higher chance to cure, since two reagents are required
	agent = "Gravitokinetic Bipotential SADS+"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	severity = DISEASE_SEVERITY_BIOHAZARD
	natural_immunity_chance = 10
	inherent_traits = list(DISEASE_SPREAD_BLOOD, DISEASE_SPREAD_CONTACT_SKIN, DISEASE_SPREAD_CONTACT_FLUIDS)

/datum/disease/gbs/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("cough")
		if(3)
			if(prob(5))
				affected_mob.emote("gasp")
			if(prob(10))
				to_chat(affected_mob, "<span class='danger'>Your body hurts all over!</span>")
		if(4)
			to_chat(affected_mob, "<span class='userdanger'>Your body feels as if it's trying to rip itself apart!</span>")
			if(prob(50))
				affected_mob.gib()
		else
			return
