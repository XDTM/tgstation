/datum/disease_property/symptom/vomit
	name = "Vomiting"
	desc = "The disease causes nausea and irritates the stomach, causing occasional vomiting."
	symptom_delay_min = 25
	symptom_delay_max = 80
	var/vomit_slip = FALSE
	var/vomit_distance = 0
	threshold_desc = "<b>ALPHA:</b> Makes the vomiting reflex more severe, causing projectile vomiting.<br>\
					  <b>BETA:</b> Makes the vomit slippery.<br>\
					  <b>Stealth 4:</b> The symptom remains hidden until active."

/datum/disease_property/symptom/vomit/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE
	if(A.properties["resistance"] >= 7) //blood vomit
		vomit_slip = TRUE
	if(A.properties["transmittable"] >= 7) //projectile vomit
		vomit_distance = 4

/datum/disease_property/symptom/vomit/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, "<span class='warning'>[pick("You feel nauseated.", "You feel like you're going to throw up!")]</span>")
		else
			vomit(M)

/datum/disease_property/symptom/vomit/proc/vomit(mob/living/carbon/M)
	M.vomit(20, FALSE, distance = vomit_distance)
