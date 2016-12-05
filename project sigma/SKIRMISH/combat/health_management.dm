



mob
	var
		base_health	= 125
		health		= 0
		can_die		= 1
		can_hit		= 1
		has_revive	= 0		// CAN HAVE A MAXIMUM OF TWO REVIVES. this number reflects the total amount the player has
		shield		= 0

	proc
		edit_health(damage, mob/dealer, bloody_mess = 0)
			if(active_game.started != 2) return
			if(damage > 0)			// restoring health
				health += damage
				if(health > base_health)
					health = base_health

			else if(!active_game.intermission && can_hit)	// or taking health
				if(istype(src, /mob/npc/hostile) && !(src in ai_list)) return
				can_hit = 0
				if(dealer)
					if(dealer.type == /mob/player && istype(src, /mob/npc/hostile))
						src:last_attacker = dealer
				if(shield)							// if they have a shield, we can avoid taking health.
					shield(-1, (client?0:1))
				else									// if they don't, however..
					health += damage
					gs(pick('hit 1.wav','hit 2.wav'))
					if(client) src:hurtflash()
					if(bloody_mess)	// 1 if explosion
						//	k_sound(src, SOUND_SPLATTER)
						drop_blood(3,1)
						drop_blood(10)
					else
						drop_blood(3)
				if(health <= 0)
					health = 0
					if(can_die)
						if(client && (has_revive || active_game.intermission))
							world << "<b>[src] was revived!"
							has_revive	--
							health 		= base_health
							can_hit 	= 1
						else
							death()
				spawn(3) if(health) can_hit = 1  //!client?3:10


		death()
			density	= 0
			can_hit	= 0
			if(is_explosive)
				animate(src, color = "#f4dd2c", time = 2, loop = 4)
				animate(color = null, time=2)
				sleep 12
			else if(istype(src, /mob/player))
				animate(src, alpha = 0, time = 1, loop = 4)
				animate(alpha = 255,time=1)
				sleep 8
				gs('dying.wav')