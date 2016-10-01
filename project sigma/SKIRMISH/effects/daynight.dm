var/max_darkness = 190


mob/player
	var/tmp
		obj/hud/daynight/daynight = new
	proc
		toggle_daynight(i = 0)
			/* call this to enable or disable the day/night effect for a given player.
				src.toggle_daynight(1) will enable day/night.
				src.toggle_daynight() AND src.toggle_daynight(0) will disable day/night.
			*/
			if(i) client.screen.Add(daynight)
			else	client.screen.Remove(daynight)


obj/hud

	daynight
		/*	this is a HUD object that gets cast across client.screen so day/night effects can be easily enabled/disabled for different players depending on their
			location and such. (for example, if you're inside a cave, it shouldn't be sunny. Or if you're in a lit house at night, it shouldn't stay dark when you go inside.
			*/
		icon			= 'effects/weather.dmi'
		icon_state		= "black"	// fr, just flood the icon_state you want to use with white so you just have a big white square.
		screen_loc		= "SOUTHWEST to NORTHEAST"
		plane			= 1
		mouse_opacity 	= 0
		var/tmp/lastenemies

		refresh()

			if(active_game.started == 2 && lastenemies != active_game.enemies_left && !active_game.boss_mode)
				lastenemies = active_game.enemies_left
				var/n_alpha = 65*sin((180*lastenemies)/active_game.enemies_total)+160//190
				if(n_alpha > max_darkness) n_alpha = max_darkness
				animate(src, alpha = n_alpha, time = 5)
