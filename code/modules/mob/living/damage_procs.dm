
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE)
	var/hit_percent = (100-blocked)/100
	if(!damage || (hit_percent <= 0))
		return 0
	switch(damagetype)
		if(BRUTE)
			take_bodypart_damage(brute = (damage * hit_percent))
		if(BURN)
			take_bodypart_damage(burn = (damage * hit_percent))
		if(TOX)
			adjustToxLoss(damage * hit_percent)
		if(OXY)
			adjustOxyLoss(damage * hit_percent)
		if(CLONE)
			adjustCloneLoss(damage * hit_percent)
		if(STAMINA)
			take_bodypart_damage(stamina = (damage * hit_percent))
		if(BRAIN)
			adjustBrainLoss(damage * hit_percent)
	return 1

/mob/living/proc/get_damage_amount(damagetype = BRUTE)
	switch(damagetype)
		if(BRUTE)
			return getBruteLoss()
		if(BURN)
			return getFireLoss()
		if(TOX)
			return getToxLoss()
		if(OXY)
			return getOxyLoss()
		if(CLONE)
			return getCloneLoss()
		if(STAMINA)
			return getStaminaLoss()
		if(BRAIN)
			return getBrainLoss()

/mob/living/proc/apply_effect(effect = 0,effecttype = EFFECT_STUN, blocked = FALSE)
	var/hit_percent = (100-blocked)/100
	if(!effect || (hit_percent <= 0))
		return 0
	switch(effecttype)
		if(EFFECT_STUN)
			Stun(effect * hit_percent)
		if(EFFECT_KNOCKDOWN)
			Knockdown(effect * hit_percent)
		if(EFFECT_UNCONSCIOUS)
			Unconscious(effect * hit_percent)
		if(EFFECT_IRRADIATE)
			radiation += max(effect * hit_percent, 0)
		if(EFFECT_SLUR)
			slurring = max(slurring,(effect * hit_percent))
		if(EFFECT_STUTTER)
			if((status_flags & CANSTUN) && !has_trait(TRAIT_STUNIMMUNE)) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * hit_percent))
		if(EFFECT_EYE_BLUR)
			blur_eyes(effect * hit_percent)
		if(EFFECT_DROWSY)
			drowsyness = max(drowsyness,(effect * hit_percent))
		if(EFFECT_JITTER)
			if((status_flags & CANSTUN) && !has_trait(TRAIT_STUNIMMUNE))
				jitteriness = max(jitteriness,(effect * hit_percent))
	return 1


/mob/living/proc/apply_effects(stun = 0, knockdown = 0, unconscious = 0, irradiate = 0, slur = 0, stutter = 0, eyeblur = 0, drowsy = 0, blocked = FALSE, stamina = 0, jitter = 0)
	if(blocked >= 100)
		return 0
	if(stun)
		apply_effect(stun, EFFECT_STUN, blocked)
	if(knockdown)
		apply_effect(knockdown, EFFECT_KNOCKDOWN, blocked)
	if(unconscious)
		apply_effect(unconscious, EFFECT_UNCONSCIOUS, blocked)
	if(irradiate)
		apply_effect(irradiate, EFFECT_IRRADIATE, blocked)
	if(slur)
		apply_effect(slur, EFFECT_SLUR, blocked)
	if(stutter)
		apply_effect(stutter, EFFECT_STUTTER, blocked)
	if(eyeblur)
		apply_effect(eyeblur, EFFECT_EYE_BLUR, blocked)
	if(drowsy)
		apply_effect(drowsy, EFFECT_DROWSY, blocked)
	if(stamina)
		apply_damage(stamina, STAMINA, null, blocked)
	if(jitter)
		apply_effect(jitter, EFFECT_JITTER, blocked)
	return 1


/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	bruteloss = CLAMP((bruteloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	oxyloss = CLAMP((oxyloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(status_flags & GODMODE)
		return 0
	oxyloss = amount
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	toxloss = CLAMP((toxloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/setToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	toxloss = amount
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	fireloss = CLAMP((fireloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	cloneloss = CLAMP((cloneloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/setCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	cloneloss = amount
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/getBrainLoss()
	. = 0

/mob/living/proc/adjustBrainLoss(amount, maximum = BRAIN_DAMAGE_DEATH)
	return

/mob/living/proc/setBrainLoss(amount)
	return

/mob/living/proc/getStaminaLoss()
	return staminaloss

/mob/living/proc/adjustStaminaLoss(amount, updating_stamina = TRUE, forced = FALSE)
	return

/mob/living/proc/setStaminaLoss(amount, updating_stamina = TRUE, forced = FALSE)
	return

// adjust proc when the value can be positive or negative
/mob/living/proc/adjust_bodypart_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	var/brute_d = max(brute, 0)
	var/burn_d = max(burn, 0)
	var/stamina_d = max(stamina, 0)
	if(brute_d || burn_d || stamina_d)
		take_bodypart_damage(brute_d, burn_d, stamina_d, only_robotic, only_organic, updating_health)
	var/brute_h = min(brute, 0)
	var/burn_h = min(burn, 0)
	var/stamina_h = min(stamina, 0)
	if(brute_h || burn_h || stamina_h)
		heal_bodypart_damage(-brute_h, -burn_h, -stamina_h, only_robotic, only_organic, updating_health)
	
// heal ONE bodypart, bodypart gets randomly selected from damaged ones.
/mob/living/proc/heal_bodypart_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	adjustBruteLoss(-brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(-burn, FALSE)
	adjustStaminaLoss(-stamina, FALSE)
	if(updating_health)
		updatehealth()
		update_stamina()

// damage ONE bodypart, bodypart gets randomly selected.
/mob/living/proc/take_bodypart_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	adjustBruteLoss(brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(burn, FALSE)
	adjustStaminaLoss(stamina, FALSE)
	if(updating_health)
		updatehealth()
		update_stamina()

// adjust proc when the value can be positive or negative
/mob/living/proc/adjust_overall_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	var/brute_d = max(brute, 0)
	var/burn_d = max(burn, 0)
	var/stamina_d = max(stamina, 0)
	if(brute_d || burn_d || stamina_d)
		take_overall_damage(brute_d, burn_d, stamina_d, only_robotic, only_organic, updating_health)
	var/brute_h = min(brute, 0)
	var/burn_h = min(burn, 0)
	var/stamina_h = min(stamina, 0)
	if(brute_h || burn_h || stamina_h)
		heal_overall_damage(brute_h, burn_h, stamina_h, only_robotic, only_organic, updating_health)		
		
// heal MANY bodyparts, in random order
/mob/living/proc/heal_overall_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	adjustBruteLoss(-brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(-burn, FALSE)
	adjustStaminaLoss(-stamina, FALSE)
	if(updating_health)
		updatehealth()
		update_stamina()

// damage MANY bodyparts, in random order
/mob/living/proc/take_overall_damage(brute = 0, burn = 0, stamina = 0, only_robotic = FALSE, only_organic = TRUE, updating_health = TRUE)
	adjustBruteLoss(brute, FALSE) //zero as argument for no instant health update
	adjustFireLoss(burn, FALSE)
	adjustStaminaLoss(stamina, FALSE)
	if(updating_health)
		updatehealth()
		update_stamina()

//heal up to amount damage, in a given order
/mob/living/proc/heal_ordered_damage(amount, list/damage_types)
	. = amount //we'll return the amount of damage healed
	for(var/i in damage_types)
		var/amount_to_heal = min(amount, get_damage_amount(i)) //heal only up to the amount of damage we have
		if(amount_to_heal)
			apply_damage_type(-amount_to_heal, i)
			amount -= amount_to_heal //remove what we healed from our current amount
		if(!amount)
			break
	. -= amount //if there's leftover healing, remove it from what we return
