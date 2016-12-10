
mob
	var/tmp
		obj/hud/health_meter/health_disp	= new
	proc
		draw_health(x_offset = 0, y_offset = 0)
			health_disp.icon 		= 'meterhealth.dmi'
			health_disp.icon_state	= "29"
			health_disp.pixel_x 	= x_offset
			health_disp.pixel_y		= y_offset
			overlays += health_disp
			if(!client) health_loop()

		health_loop()
			set waitfor = 0
			var/i = 0
			while(src)
				i++
				if(i >= 10 && health && health < base_health && !active_game.dis_regenerate)
					i = 0
					health += 1
				if(health_disp)
					if(health_disp.icon_state != "[round((health/base_health)*29)]")
						overlays -= health_disp
						health_disp.icon_state 	= "[round((health/base_health)*29)]"
						overlays += health_disp
				sleep 1


	player
		proc
			refresh_hud()
				/*
					this proc loops on the player when they log in and handles all the HUD stuff.
				*/
				set waitfor = 0
				toggle_daynight(1)	// add the lighting layer.
				draw_health(-5, 32)
				client.screen += scanlines
				client.screen += new /obj/hud/clip_status
				client.screen += new /obj/hud/kill_counter
				client.screen += new /obj/hud/wave_counter
				overlays += REVIVES
				var/i = 0
				while(src)
					i++
					if(i >= 10 && health && health < base_health && !active_game.dis_regenerate)
						i = 0
						health += 1
					if(health_disp)
						if(health_disp.icon_state != "[round((health/base_health)*29)]")
							overlays -= health_disp
							health_disp.icon_state 	= "[round((health/base_health)*29)]"
							overlays += health_disp
					if(REVIVES)
						if(REVIVES.icon_state != "revive[has_revive]")
							overlays -= REVIVES
							REVIVES.icon_state = "revive[has_revive]"
							overlays += REVIVES

					for(var/obj/hud/h in client.screen)	// only loop through hud objects that are currently being displayed.
						h.refresh(src)					// refresh each! If you need to reference the player in the refresh proc, just add it to the object's refresh proc's arguments.
					sleep 1




obj/hud
	/* you can build your own hud system around this(it's a good setup) or just port the important parts to your own setup.
		*/
	proc
		refresh()
			/* called on each /obj/hud in the client's screen every 5 ticks.
				what you put in this proc for each object will be carried out as long as the object is in client.screen
			*/

	health_meter
		icon				= 'meterhealth.dmi'
		icon_state			= "14"
		appearance_flags	= NO_CLIENT_COLOR
		plane				= 2


	clip_status
		/*	this is a HUD object that gets cast across client.screen so day/night effects can be easily enabled/disabled for different players depending on their
			location and such. (for example, if you're inside a cave, it shouldn't be sunny. Or if you're in a lit house at night, it shouldn't stay dark when you go inside.
			*/
		screen_loc		= "SOUTH+1,WEST"
		maptext_width	= 128
		maptext_height	= 32
		maptext			= "--/--"
		pixel_x			= 2
		plane			= 2
		mouse_opacity 	= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/tmp/last_mag

		refresh(mob/player/p)

			if(active_game.started == 2)

				if(p.client.fs && screen_loc != "SOUTH+1,WEST+1:2")
					screen_loc	= "SOUTH+1,WEST+1:2"
				if(!p.client.fs && screen_loc != "SOUTH+1,WEST:2")
					screen_loc	= "SOUTH+1,WEST:2"
				if(istype(p.equipped_weapon, /obj/weapon/gun))
					if(p.equipped_weapon:mag != last_mag)
						last_mag 	= p.equipped_weapon:mag
						maptext		= "[p.equipped_weapon:mag]/[p.equipped_weapon:mag_size]"
				else if(last_mag != "--/--")
					last_mag 	= "--/--"
					maptext		= "--/--"


	kill_counter
		screen_loc		= "NORTH-1,WEST"
		maptext_width	= 128
		maptext_height	= 32
		maptext			= "0 kills"
		pixel_x			= 2
		plane			= 2
		mouse_opacity 	= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/tmp/last_kills

		refresh(mob/player/p)

			if(active_game.started == 2)

				if(p.client.fs && screen_loc != "NORTH-1,WEST+1:2")
					screen_loc	= "NORTH-1,WEST+1:2"
				if(!p.client.fs && screen_loc != "NORTH-1,WEST:2")
					screen_loc	= "NORTH-1,WEST:2"
				if(last_kills != p.kills)
					last_kills = p.kills
					maptext	= "[last_kills] kills"


	wave_counter
		screen_loc		= "NORTH-1,CENTER"
		maptext_width	= 128
		maptext_height	= 32
		maptext			= "Wave -"
		plane			= 2
		mouse_opacity 	= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/tmp/last_wave

		refresh(mob/player/p)

			if(active_game.started == 2)
				if(p.client.fs && screen_loc != "NORTH-1,CENTER")
					screen_loc	= "NORTH-1,CENTER"
				if(!p.client.fs && screen_loc != "NORTH-1,CENTER")
					screen_loc	= "NORTH-1,CENTER"
				if(last_wave != active_game.current_round)
					last_wave = active_game.current_round
					maptext	= "Wave [last_wave]"