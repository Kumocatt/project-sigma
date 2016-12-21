

mob
	player
		var/tmp
			can_sprint	= 1

		verb
			sprint()
				set hidden = 1
				if(health && loc && can_sprint)
					can_sprint 	= 0
					can_hit		= 0
					. = 0
					if(!on_fire && !fireproof || on_fire && prob(15))
						. = 1
						fireproof = 1
					animate(src, pixel_z = 8, time = 2, loop = 1)
					animate(pixel_z = 0, time = world.tick_lag*2, loop = 1, easing = BOUNCE_EASING)
					src << SOUND_JUMP
					if(key1)
						for(var/i = 1 to 6)
							dust()
							step(src, dir, step_size+2)
							sleep world.tick_lag
					else
						dust()
					if(.) fireproof	= 0
					can_hit		= 1
					sleep 5
					can_sprint 	= 1

atom/movable
	proc/dust()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "dust[rand(1,3)]";o.pixel_x = -4;o.pixel_y = -12
		animate(o,transform = turn(matrix()*2,rand(180,360)),alpha=0,time=5)
		o.spawndel(5)

	proc/smoke()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "smoke[rand(1,3)]";o.layer = EFFECTS_LAYER;o.alpha = 155
		animate(o,transform = turn(matrix()*5,rand(180,360)), pixel_y = 16,alpha=100,time=15)
		animate(transform = turn(matrix()*5,rand(180,360)), alpha = 0, time = 45)
		o.spawndel(60)

	proc/twinkle()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "sparkle[pick(1,2)]";o.pixel_x = -4;o.pixel_y = 2;o.plane = 3
		animate(o,transform = turn(matrix()/2,rand(180,360)),alpha=0,time=15)
		o.spawndel(15)

	proc/rocketcloud()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'combat/projectiles.dmi';o.icon_state = "cloud[rand(1,3)]";o.plane = 2
		animate(o,transform = transform*2, pixel_y = 32, alpha = 100,time = 30)
		animate(transform = transform*5, pixel_y = 48, pixel_x = -32, alpha = 0,time = 50)
		o.spawndel(80)