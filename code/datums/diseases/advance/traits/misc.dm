/datum/disease_property/trait/immolation
	name = "Immolation"
	desc = "The disease accelerates its metabolism to the point of self-destruction, increasing its stats but causing it to burn out \
	and cure itself some time after the final stage. Faster diseases are quicker to burn out."
	resistance = 4
	speed = 4
	infectivity = 4
	//Lasts 1:30 minutes at speed 10, 15 minutes at speed 1
	var/burnout = 900

/datum/disease_property/trait/immolation/on_process()
	..()
	burnout -= disease.stats["speed"]
	if(burnout <= 0)
		disease.cure()

