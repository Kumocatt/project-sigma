
mob/player
	var
		obj/screen_obj/wave_complete/waveComplete 	= new
		obj/screen_obj/scanlines/scanlines			= new

obj
	screen_obj
		plane = 3
		background
			icon				= 'backdrop.png'
		wave_complete
			icon				= 'wavecomplete.png'
			screen_loc			= "1,1"
		scanlines
			icon				= 'interface/x16.dmi'
			icon_state			= "scanlines"
			screen_loc			= "SOUTHWEST to NORTHEAST"
			alpha				= 22
			appearance_flags	= BLEND_MULTIPLY


