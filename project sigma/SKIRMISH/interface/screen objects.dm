
mob/player
	var
		obj/screen_obj/wave_complete/waveComplete 	= new
		obj/screen_obj/wave_start/waveStart	 		= new
		obj/screen_obj/deathmatch/deathmatch		= new
		obj/screen_obj/scanlines/scanlines			= new
		obj/screen_obj/hurt_flash/hurtflash			= new

	proc
		hurtflash()
			set waitfor = 0
			client.screen += hurtflash
			animate(hurtflash, alpha = 200, time = 2, easing = ELASTIC_EASING)
			animate(alpha = 0, time = 1)
			sleep 3
			client.screen -= hurtflash

obj
	screen_obj
		plane = 3
		background
			icon				= 'backdrop.png'
		wave_complete
			icon				= 'wavecomplete.png'
			screen_loc			= "SOUTHWEST"
		wave_start
			icon				= 'wavestart.png'
			screen_loc			= "SOUTHWEST"
		deathmatch
			icon				= 'deathmatchwave.png'
			screen_loc			= "SOUTHWEST"
		scanlines
			icon				= 'interface/x16.dmi'
			icon_state			= "scanlines"
			screen_loc			= "SOUTHWEST to NORTHEAST"
			alpha				= 44
			appearance_flags	= BLEND_MULTIPLY
		hurt_flash
			icon				= 'interface/x16.dmi'
			icon_state			= "hurt"
			screen_loc			= "SOUTHWEST to NORTHEAST"
			alpha				= 0
			appearance_flags	= BLEND_MULTIPLY
