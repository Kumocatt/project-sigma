



mob
	var
		base_health	= 125
		health		= 0
		can_die		= 1
		can_hit		= 1
		has_revive	= 0
		has_shield	= 0

	proc
		edit_health(damage, mob/dealer, bloody_mess = 0)
			if(damage > 0)			// restoring health
				health += damage
				if(health > base_health)
					health = base_health

			else if(!active_game.intermission && can_hit)	// or taking health
				can_hit = 0
				if(dealer)
					if(dealer.type == /mob/player && istype(src, /mob/npc/hostile))
						src:last_attacker = dealer
				if(has_shield)							// if they have a shield, we can avoid taking health.
					has_shield --
					if(!has_shield)
						overlays.Remove(SHIELD_OVERLAY1, SHIELD_OVERLAY2)
				else									// if they don't, however..
					health += damage
					if(bloody_mess)	// 1 if explosion
						//	k_sound(src, SOUND_SPLATTER)
						drop_blood(3,1)
						drop_blood(10)
					else
						drop_blood(5)
				if(health <= 0)
					health = 0
					if(can_die)
						if(client && (has_revive || active_game.intermission))
							world << "<b>[src] was revived!"
							has_revive	= 0
							health 		= base_health
							can_hit 	= 1
						else
							death()
				spawn(!client?2:10) if(health) can_hit = 1


		death()
			density	= 0
			can_hit	= 0
			if(is_explosive)
				animate(src, color = "#f4dd2c", time = 1, loop = 4)
				animate(color = null, time=1)
			else
				animate(src, alpha = 0, time = 1, loop = 4)
				animate(alpha = 255,time=1)
			sleep client?8:2