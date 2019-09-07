#define FLUX_TIDE_FAST "fast"
#define FLUX_TIDE_NORMAL "normal"
#define FLUX_TIDE_SLOW	"slow"
#define FLUX_TIDE_STOP	"stop"

///Lets the host survive indefinitely when in crit.
/datum/disease_property/symptom/temporal_flux
	name = "Temporal Flux"
	desc = "The disease uses exotic matter to store and release time in a regular cycle, alternately speeding up and slowing the host."
	var/time_tide = 1
	var/tide_rising = TRUE
	var/current_effect = FLUX_TIDE_NORMAL
	threshold_desc = "<b>DELTA:</b> Makes the host able to survive normally fatal amounts of damage, although they will still be incapacitated.<br>\
					  <b>EPSILON:</b> Allows the host to ignore critical injuries, allowing them to stay active until the disease runs out of reserves.<br>"

/datum/disease_property/symptom/temporal_flux/update_mutators()
	return

/datum/disease_property/symptom/temporal_flux/on_process()
	..()
	if(disease.stage >= 5)
		if(tide_rising)
			time_tide++
		else
			time_tide--
		apply_tide()

/datum/disease_property/symptom/temporal_flux/proc/apply_tide()
	var/mob/living/carbon/human/H = disease.affected_mob
	if(!ishuman(H))
		return
	if(current_effect == FLUX_TIDE_STOP)
		return
	switch(time_tide)
		if(0)
			tide_rising = TRUE
		if(1 to 15)
			if(current_effect == FLUX_TIDE_NORMAL)
				current_effect = FLUX_TIDE_FAST
				H.physiology.do_after_speed *= 0.50
				H.add_movespeed_modifier(MOVESPEED_ID_TEMPORAL_FLUX, update=TRUE, priority=100, multiplicative_slowdown=-1)
				to_chat(H, "<span class='notice'>[pick("Everything around you seems to slow down.","You feel faster.","You feel like time is on your side.")]</span>")
		if(16 to 25)
			if(current_effect == FLUX_TIDE_FAST)
				current_effect = FLUX_TIDE_NORMAL
				H.physiology.do_after_speed /= 0.50
				H.remove_movespeed_modifier(MOVESPEED_ID_TEMPORAL_FLUX)
				to_chat(H, "<span class='notice'>[pick("Time seems to have returned to normality.","You no longer feel faster.","You return to your regular speed.")]</span>")
			if(current_effect == FLUX_TIDE_SLOW)
				current_effect = FLUX_TIDE_NORMAL
				H.physiology.do_after_speed *= 0.50
				H.remove_movespeed_modifier(MOVESPEED_ID_TEMPORAL_FLUX)
				to_chat(H, "<span class='notice'>[pick("Time seems to have returned to normality.","You no longer feel slower.","You return to your regular speed.")]</span>")
		if(26 to 30)
			if(current_effect == FLUX_TIDE_NORMAL)
				current_effect = FLUX_TIDE_SLOW
				H.physiology.do_after_speed /= 0.50
				H.add_movespeed_modifier(MOVESPEED_ID_TEMPORAL_FLUX, update=TRUE, priority=100, multiplicative_slowdown=2)
				to_chat(H, "<span class='notice'>[pick("Everything around you seems to speed up.","You feel slower.","You feel like time is against you.")]</span>")
		if(31)
			to_chat(H, "<span class='notice'>[pick("You feel much, much slower.","Time crawls to a stop.","You feel like you ran out of time.")]</span>")
			time_stop()
			tide_rising = FALSE

/datum/disease_property/symptom/temporal_flux/proc/time_stop()
	var/obj/effect/timestop/temporal_flux/timestop = new (get_turf(disease.affected_mob), 0, 50)
	timestop.symptom = src

/obj/effect/timestop/temporal_flux
	name = "waxing temporal flux"
	desc = "Someone appears to have run out of time..."
	icon = null
	icon_state = null
	var/datum/disease_property/symptom/temporal_flux/symptom

/obj/effect/timestop/temporal_flux/Destroy()
	. = ..()
	symptom.current_effect = FLUX_TIDE_SLOW
