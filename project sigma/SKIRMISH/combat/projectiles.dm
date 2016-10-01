
var/tmp
	list/active_projectiles	= new

proc
	projectile_loop()
		/*
			all the active projectiles on the map are tracked by this proc.
		*/
		set waitfor = 0
		for()
			if(active_projectiles.len) for(var/obj/projectile/p in active_projectiles)
				p.take_step()
			sleep world.tick_lag

atom
	var/d_ignore		= 0	// toggle this on a dense atom and projectiles will ignore the atom's density.

obj
	projectile
		icon			= 'projectiles.dmi'
		is_garbage		= 1
		step_size		= 6
		bound_x			= 7
		bound_y			= 4
		bound_width		= 3
		bound_height	= 3
		plane			= 2
		density			= 1
		var/tmp
			hp_modifier	= -1		// the hp of mobs that the projectile hits will be effected by this value. positive will heal, negative will damage.
			penetration	= 100	// the probability of the projectile penetrating through a collided mob.
			px_range	= 128	// the distance(in pixels) that the projectile can travel before being being culled.(** if(step_size*total_steps > px_range) **)
			accuracy	= 100	// every [accuracy] pixels, the projectile will stray 1px off from true center.
			total_steps	= 0		// the number of steps the projectile has made since being spawned.   damage falloff = (damage)-
			kb_dist		= 4
			velocity	= 1.5
		/*
			these variables cannot be edited.
	*/
			sway 			= 1	// positive or negative ; used to help track the direction that projectiles should sway
			mob/owner
			accur_assist	= 0	// used to assist with tracking accuracy offsets.
			is_crit			= 0	// used to keep track of critical shots.

		GC()
			hp_modifier		= -1	// important to reset to 0 so that it gets recognized as a new projectile when reused.
			penetration		= 100
			total_steps		= 0
			owner			= null
			accur_assist	= 0
			is_crit			= 0
			color			= null
			..()

		Bump(atom/a)
			if(istype(a, /obj/projectile) || a.d_ignore)
				loc = get_step(src, dir)
				return
			if(ismob(a))
				if(a == owner)
					loc = get_step(src, dir)
					return
				loc			= null
				var/mob/m 	= a
				if(m.can_hit)
					m.knockback(6, dir)
					m.edit_health((is_crit ? hp_modifier : hp_modifier+hp_modifier), owner)
			if(istype(a, /atom/movable) && a:is_explosive && !ismob(a))
				a:Explode(32, -100, owner)
			GC()



		proc
			take_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
					GC()
				else
					if(loc)
						total_steps ++
						if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
							accur_assist = round((step_size*total_steps)/accuracy)
							if(dir == EAST || dir == WEST)	step_y += sway
							else 							step_x += sway
						trail(is_crit)
						step(src, dir)
						sleep world.tick_lag*velocity


			trail(crit = 0)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "[icon_state]-trail";o.plane = 2
				if(crit) 	animate(o, alpha=0, transform = turn(transform, 360), color = "red",time=5)
				else		animate(o, alpha=0, transform = turn(transform, 360), time=5)
				o.spawndel(5)


		thrown
			icon			= 'projectiles.dmi'
			is_garbage		= 1
			step_size		= 4
			bound_x			= 7
			bound_y			= 4
			bound_width		= 3
			bound_height	= 3
			plane			= 2
			density			= 1
			var/tmp
				end_step 	= 0

			grenade
				icon_state	= "grenade"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 1

				hp_modifier	= -5
				penetration	= 0
				px_range	= 64
				accuracy	= 25	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5

				GC()
					end_step = 0
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						sleep 15
						Explode(32, -50, owner)
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if(dir == EAST || dir == WEST)
								if((step_size*total_steps) < (px_range/2)) pixel_y += 1
								else pixel_y -= 1
							step(src, dir)
							sleep world.tick_lag
				Bump(atom/a)
					if(istype(a, /obj/projectile))
						loc = get_step(src, dir)
						return
					if(a.d_ignore)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1


/*
		shuriken
			icon		= '_Bullets.dmi'
			icon_state	= "shuriken"
			density		= 1
			step_size	= 5
			bound_width	= 8
			bound_height= 8
	/*		init_step()
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
					GC()*/

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
	/*		init_step()
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

*/
		molotov
			icon		= '_Bullets.dmi'
			icon_state	= "molotov"
			density		= 1
			step_size	= 2
			bound_width	= 8
			bound_height= 8
/*
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
*/
		firewall
			icon		= 'projectiles.dmi'
			icon_state	= "firewall"
			density		= 1
			step_size	= 2
			bound_width	= 8
			bound_height= 8
/*
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
*/

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
	/*		init_step()
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
				end_move = 1*/
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
	/*		init_step()
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
				end_move = 1*/
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
	/*		init_step()
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
*/
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
	/*		init_step()
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
*/
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
			px_range	= 20// needs to be four tiles over detonation point.
			plane		= 2
			var/end_move= 0
			GC()
				icon_state		= "rocket1"
				end_move 		= 0
				is_explosive	= 0
				..()
/*			init_step()
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
			*/

			*/