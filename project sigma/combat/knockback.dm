


mob
	var/tmp
		kb_init	= 0
		can_kb	= 1
	proc
		knockback(dist = 2, _dir = NORTH)
			set waitfor = 0
			if(kb_init || !can_kb) return
			kb_init 	= 1
			if(istype(src, /mob/player)) spawn
				src:screenshake()
			var/i		= dist
			var/og_dir	= dir
			while(i > 0 && kb_init)
				if(!loc) break
				dust()
				step(src, _dir, 6)
				dir	= og_dir
				i --
				sleep world.tick_lag
			if(kb_init) kb_init = 0

