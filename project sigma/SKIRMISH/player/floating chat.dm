


obj/floatChat
	maptext_width	= 84
	maptext_height	= 64
	plane			= 2
	appearance_flags= NO_CLIENT_COLOR
	pixel_x			= -32
	pixel_y			= 36



mob
	var/tmp
		obj/float_box	= new /obj/floatChat


	proc
		float_text(txt = "null", floattime = 5)
			/* call to float some text over an atom.
			*/
			if(txt)
				if(float_box.maptext)
					if(float_box.maptext == "<center><b>[html_encode(txt)]") return
					overlays -= float_box
				float_box.maptext	= "<center><b>[html_encode(txt)]"
				overlays += float_box
				sleep 10*floattime
				if(float_box.maptext == "<center><b>[html_encode(txt)]")
					overlays -= float_box
					float_box.maptext = null