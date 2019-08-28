/*!
	Makes the mob grow a massive beard, regardless of gender.
*/

/datum/disease_property/symptom/beard
	name = "Facial Hypertrichosis"
	desc = "The virus increases hair production significantly, causing rapid beard growth."
	symptom_delay_min = 18
	symptom_delay_max = 36

	var/list/beard_order = list("Beard (Jensen)", "Beard (Full)", "Beard (Dwarf)", "Beard (Very Long)")

/datum/disease_property/symptom/beard/activate(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/index = min(max(beard_order.Find(H.facial_hair_style)+1, A.stage-1), beard_order.len)
		if(index > 0 && H.facial_hair_style != beard_order[index])
			to_chat(H, "<span class='warning'>Your chin itches.</span>")
			H.facial_hair_style = beard_order[index]
			H.update_hair()

