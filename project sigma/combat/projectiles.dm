
var/tmp/list/active_projectiles	= new

proc
	projectile_loop()
		set waitfor = 0
		for()
			var/obj/projectile/p
			if(active_projectiles.len)
				p = active_projectiles[1]
				p.init_step()
			else sleep world.tick_lag

atom
	var
		d_ignore		= 0
obj
	projectile
		is_garbage		= 1
		step_size		= 6
		is_explosive	= 0

		var/tmp
			damage			= -1
			max_step		= 1
			accuracy		= 0
			kb_dist			= 4	// how many times the knockback should step.
			manual_termin	= 0
			can_penetrate	= 0
		/*
			these variables cannot be edited.
	*/
			sway 			= 1	// positive or negative ; used to help track the direction that projectiles should sway.
			last_step		= 0	// used to track how far the projectile has traveled.
			mob/owner
			accuracy_helper = 0
			is_crit			= 0

		GC()
			last_step		= 0	// important to reset to 0 so that it gets recognized as a new projectile when reused.
			accuracy_helper	= 0
			is_crit			= 0
			color			= null
			..()

		Bump(atom/a)
			if(istype(a, /obj/projectile))
				loc = get_step(src, dir)
				return
			if(a.d_ignore)
				loc = get_step(src, dir)
				return
			if(ismob(a) )//&& a != owner)
				loc			= null
				var/mob/m 	= a
				if(m.can_hit)
					m.knockback(6, dir)
					m.edit_health((is_crit ? damage : damage+damage), owner)
			if(istype(a, /atom/movable) && a:is_explosive && !ismob(a))
				a:Explode(32, -100, owner)
			GC()

		proc
			init_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
				//		world << "DEBUG - projectile was cleaned up via collision."
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					trail(is_crit)
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
				//	world << "DEBUG - projectile reached max range."
					GC()


			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "trail"//[rand(1,3)]"//;o.layer = EFFECTS_LAYER
				if(crit) 	animate(o, alpha=0, transform = turn(transform, 360), color = "red",time=5)
				else		animate(o, alpha=0, transform = turn(transform, 360), time=5)
				o.spawndel(5)


		bullet
			icon		= 'projectiles.dmi'
			icon_state	= "bullet"
			density		= 1
			step_size	= 6
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3

		laser
			icon		= 'projectiles.dmi'
			icon_state	= "laser"
			density		= 1
			step_size	= 8
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			plane		= 2
			blend_mode  = BLEND_ADD
			can_penetrate= 1
			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "laser-trail";o.plane = 2;o.dir = dir;o.blend_mode = BLEND_ADD
				if(crit) 	animate(o, alpha=0, color = "red",time=5)
				else		animate(o, alpha=0, time=5)
				o.spawndel(5)
		laser2
			icon		= 'projectiles.dmi'
			icon_state	= "laser2"
			density		= 1
			step_size	= 8
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			plane		= 2
			blend_mode  = BLEND_ADD
			can_penetrate= 1
			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "laser2-trail";o.plane = 2;o.dir = dir;o.blend_mode = BLEND_ADD
				if(crit) 	animate(o, alpha=0, color = "red",time=5)
				else		animate(o, alpha=0, time=5)
				o.spawndel(5)
		laser3
			icon		= 'projectiles.dmi'
			icon_state	= "laser3"
			density		= 1
			step_size	= 8
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			plane		= 2
			blend_mode  = BLEND_ADD
			can_penetrate= 1
			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "laser3-trail";o.plane = 2;o.dir = dir;o.blend_mode = BLEND_ADD
				if(crit) 	animate(o, alpha=0, color = "red",time=5)
				else		animate(o, alpha=0, time=5)
				o.spawndel(5)
		nyan
			icon		= 'projectiles.dmi'
			icon_state	= "nyan"
			density		= 1
			step_size	= 6
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			plane		= 2
			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "nyan-trail";o.plane = 2;o.dir = dir;o.blend_mode = BLEND_ADD
				if(crit) 	animate(o, alpha=0, color = "red",time=5)
				else		animate(o, alpha=0, time=5)
				o.spawndel(5)

		launcher
			icon		= '_Bullets.dmi'
			icon_state	= "launcher"
			density		= 1
			step_size	= 3
			bound_width	= 8
			bound_height= 8
			is_explosive= 1
			var/end_move = 0
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc || end_move)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					Explode(32, -100, owner)
			//		GC()
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				if(a.density)
					end_move = 1
					Explode(32, -100, owner)
				if(istype(a, /atom/movable) && a:is_explosive)
					a:Explode(32, -100, owner)






		bolt
			icon		= 'projectiles.dmi'
			icon_state	= "bolt"
			density		= 1
			step_size	= 5
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
		fblast
			icon		= 'projectiles.dmi'
			icon_state	= "fblast"
			density		= 1
			step_size	= 3
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					GC()

		grenade
			icon		= '_Bullets.dmi'
			icon_state	= "grenade"
			density		= 1
			step_size	= 2
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			is_explosive= 1
			var/end_move= 0
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					Explode(32, -100, owner)
			//		GC()
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				if(a.density)
					end_move = 1
			//	GC()


		shuriken
			icon		= '_Bullets.dmi'
			icon_state	= "shuriken"
			density		= 1
			step_size	= 5
			bound_width	= 8
			bound_height= 8
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					GC()

		fireball
			icon		= 'projectiles.dmi'
			icon_state	= "fireball"
			density		= 1
			step_size	= 3
			bound_width	= 8
			bound_height= 8
			plane		= 2
			appearance_flags = NO_CLIENT_COLOR
			blend_mode	= BLEND_ADD
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					GC()
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				if(ismob(a))
					loc	= null
					var/mob/m = a
					if(m.can_hit)
						m.knockback(3,dir)
						m.edit_health((is_crit ? damage : damage+damage), owner)
						m.burn(owner)
				GC()


		molotov
			icon		= '_Bullets.dmi'
			icon_state	= "molotov"
			density		= 1
			step_size	= 2
			bound_width	= 8
			bound_height= 8

			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					drop_fire(6, owner)
					GC()
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				drop_fire(6, owner)
				GC()

		firewall
			icon		= 'projectiles.dmi'
			icon_state	= "firewall"
			density		= 1
			step_size	= 2
			bound_width	= 8
			bound_height= 8

			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					drop_fire(6, owner)
					GC()
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				drop_fire(6, owner)
				GC()

			drop_fire()
				var/list/turf_list 	= new /list()
				var/turf/init_t		= loc
				turf_list += init_t
				if(dir == NORTH || dir == SOUTH)
					/*left and right spread.
					*/
					for(var/i = 1 to 3)
						turf_list += locate(init_t.x+i, init_t.y, init_t.z)
						turf_list += locate(init_t.x-i, init_t.y, init_t.z)
				else
					for(var/i = 1 to 3)
						turf_list += locate(init_t.x, init_t.y+i, init_t.z)
						turf_list += locate(init_t.x, init_t.y-i, init_t.z)
				for(var/turf/t in turf_list)
					if(!t.density)
						switch(fire_count(t))
							if(0)
						//		var/image/spotlight_o/a		= /image/spotlight_o
								var/obj/hazard/fire/f 		= garbage.Grab(/obj/hazard/fire)
								f.owner						= owner
								f.loc						= t
						//		a.loc						= f.loc
								f.step_x					= 0
								f.step_y					= 0
								f.spawndel(150)
							if(1)
								var/obj/hazard/fire/f 		= garbage.Grab(/obj/hazard/fire)
								f.owner						= owner
								f.loc						= t
								f.step_x					= 0
								f.step_y					= 8
								f.spawndel(150)


		glowstick_g
			icon		= 'projectiles.dmi'
			icon_state	= "glowstick-g"
			density		= 1
			step_size	= 4
			var/end_move= 0
			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#66FF33")
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step && !end_move)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					density	= 0
					spawndel(300)
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				end_move = 1
		glowstick_r
			icon		= 'projectiles.dmi'
			icon_state	= "glowstick-r"
			density		= 1
			step_size	= 4
			var/end_move= 0
			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#FF3333")
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step && !end_move)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					density	= 0
					spawndel(300)
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				end_move = 1
		glowstick_b
			icon		= 'projectiles.dmi'
			icon_state	= "glowstick-b"
			density		= 1
			step_size	= 4
			var/end_move= 0
			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#3399FF")
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step && !end_move)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					density	= 0
					spawndel(300)
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				end_move = 1

		airsupport
			icon		= 'projectiles.dmi'
			icon_state	= "airsupport"
			density		= 1
			step_size	= 4
			var/end_move= 0
			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#FFCC00")
			GC()
				end_move = 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step && !end_move)
					if(!loc)
						return
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						if(dir == EAST || dir == WEST)	step_y += sway
						else 							step_x += sway
					if(!end_move)
						step(src, dir)
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					sleep 50
					airstrike(loc, owner)
					spawndel(5)
			Bump(atom/a)
				if(istype(a, /obj/projectile))
					loc = get_step(src, dir)
					return
				if(a.d_ignore)
					loc = get_step(src, dir)
					return
				end_move = 1

		airstrike
			icon		= 'projectiles.dmi'
			icon_state	= "rocket1"
			density		= 0
			step_size	= 6
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3
			is_explosive= 0
			max_step	= 20// needs to be four tiles over detonation point.
			plane		= 2
			var/end_move= 0
			GC()
				icon_state		= "rocket1"
				end_move 		= 0
				is_explosive	= 0
				..()
			init_step()
				set waitfor = 0
				active_projectiles -= src
				if(last_step < max_step)
					if(!loc)
						return
					if(last_step == 8)
						animate(src, alpha = 255, transform = matrix(), time = 10, loop = 1)
					last_step ++
					if((last_step && accuracy) && round(last_step/accuracy) > accuracy_helper)
						accuracy_helper = round(last_step/accuracy)
						step_x += sway
					if(!end_move)
						step(src, SOUTH)
						rocketcloud()
					sleep world.tick_lag*1.5
					active_projectiles += src
				else
					is_explosive = 1
					Explode(32, -100, owner)
			//		GC()