mob/player
	Bump(atom/a)
		..()
		if(kb_init)
			kb_init = 0
			if(istype(a, /mob/player) || istype(a, /mob/npc))
				a:knockback(6, get_dir(src, a))
			if(istype(a, /obj/barricade/crate))
				var/obj/barricade/crate/c = a
				c.Break()
		if(istype(a, /obj/barricade) && !a:broken)
			var/obj/barricade/b = a
			b.last_pusher 		= src
			step(b, dir)
		if(istype(a, /mob/npc))
			a:knockback(4, get_dir(src, a))

obj
	barricade
		icon	= '32x32.dmi'
		density	= 1
		layer	= TURF_LAYER+0.3
		step_size= 2
		d_ignore= 1
		var/tmp
			mob/last_pusher
			broken = 0
		Bump(atom/a)
			..()
			if(last_pusher && istype(last_pusher, /mob/player) && istype(a, /obj/barricade))
				var/obj/barricade/b = a
				step(b, dir)
		cone
			icon_state	= "cone1"
		crate
			icon_state	= "crate1"
			proc
				Break()
					if(!broken)
						broken = 1
						animate(src, pixel_y = 8, time = 1)
						animate(pixel_y = 0, time = 1)
						sleep 2
						icon_state	= "crate1-broke"
						density		= 0
						for(var/i = 0, i < 6, i++)
							dust()
						ReSpawn(10)

				ReSpawn(var/i = 5)
					set waitfor = 0
					toploop
					sleep i*10
					for(var/atom/a in initial(loc))
						if(a.density) goto toploop
					animate(src, alpha = 0, time = 3, loop = 1)
					icon_state	= "crate1"
					loc 		= initial(loc)
					pixel_y		= 128
					density		= 1
					animate(src, alpha = 255, pixel_y = 0, easing = BOUNCE_EASING, time = 5, loop = 1)
					broken 		= 0