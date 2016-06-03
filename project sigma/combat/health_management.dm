



mob
	var
		base_health	= 50
		health		= 0
		can_die		= 1
		can_hit		= 1
		has_revive	= 0
		has_shield	= 0

	proc
		edit_health(damage, mob/dealer, bloody_mess = 0)
			if(damage && can_hit && !active_game.intermission)
				can_hit	= 0
				if(damage < 0)
					if(dealer)
						if(active_game.bloody_trigger) dealer.edit_health(-10)
						if(dealer.type == /mob/player && istype(src, /mob/npc/hostile))
							src:last_attacker = dealer

					if(has_shield)
						overlays -= SHIELD_OVERLAY
						has_shield = 0
					else
						health += damage
						if(bloody_mess)
						//	k_sound(src, SOUND_SPLATTER)
							drop_blood(3,1)
							drop_blood(10)
						else drop_blood(5)
						if(client)
						//	k_sound(src, SOUND_HURT)
					//		var/curcolor = client.color
							animate(client, color = "red", time = 5, loop = 1)
							animate(color = null, time = 5)
				else health += damage
				if(health<=0)
					health = 0
					if(can_die)
						if(has_revive || active_game.intermission)
							world << "<b>[src] was revived!"
							has_revive	= 0
							health 		= base_health
							can_hit 	= 1
						else
							death()
				else if(health>base_health) health = base_health
				if(!client) spawn(2) can_hit = 1
				else		spawn(10) can_hit = 1


		death()
			density	= 0
			can_hit	= 0
			if(is_explosive)
				animate(src, color = "#f4dd2c", time = 1, loop = 4)
				animate(color = null, time=1)
			else
				animate(src, alpha = 0, time = 1, loop = 4)
				animate(alpha = 255,time=1)
			sleep 8