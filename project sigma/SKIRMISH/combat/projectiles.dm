
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
				if(!p.timeout)
					p.take_step()
				if(!(p.loc))
					active_projectiles -= p							// projectiles cleaned here.
			//		world << "Projectile stuck in limbo; culled."
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
		layer			= EFFECTS_LAYER
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
			timeout			= 0

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
			if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
				if(dir == WEST) step_x -= step_size
				if(dir == EAST) step_x += step_size
				if(dir == NORTH)step_y += step_size
				if(dir == SOUTH)step_y -= step_size
			else
				loc	= null
				if(ismob(a))
					var/mob/m 	= a
					if(m.can_hit)
						m.knockback(6, dir)
						m.edit_health((is_crit ? hp_modifier : hp_modifier+hp_modifier), owner)
						if((icon_state == "firebullet" || (icon_state == "fireball" && prob(15))) && m.health) m.burn()
				if(istype(a, /atom/movable) && a:is_explosive && !ismob(a))
					a:Explode(42, -100, owner)
				GC()



		proc
			take_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				timeout = 1
				if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
					GC()
				else
					if(loc)
						total_steps ++
						if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
							accur_assist = round((step_size*total_steps)/accuracy)
							if(dir == EAST || dir == WEST)	step_y += sway
							else 							step_x += sway
						for(var/mob/player/p in obounds(src,5))				//	THIS IS FOR BULLET WHIZ SOUND EFFECT
							if(p != owner) p.ps('bulletwhiz1.wav')
						trail(is_crit, dir)
						step(src, dir)
						sleep world.tick_lag*velocity
				timeout = 0


			trail(crit = 0, _dir = null)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "[icon_state]-trail";o.plane = 2;o.layer = EFFECTS_LAYER-1;o.dir = _dir
				if(crit) 	animate(o, alpha=0, transform = turn(transform, 360), color = "red",time=5)
				else		animate(o, alpha=0, transform = turn(transform, 360), time=5)
				o.spawndel(5)



		missile
			icon_state	= "rocket1"
			density		= 0
			step_size	= 6
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3

			hp_modifier	= -5
			penetration	= 0
			accuracy	= 8	// every [accuracy] pixels, the projectile will stray 1px off from true center.
			kb_dist		= 0
			velocity	= 0.5
			px_range	= 60
			plane		= 2

			GC()
				icon_state		= "rocket1"
				is_explosive	= 0
				..()

			take_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				timeout = 1
				if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
					is_explosive = 1
					Explode(42, -100, owner)
				else
					if(loc)
						if(total_steps == 1)
							animate(src, alpha = 150, time = 1, loop = 1)
						if(total_steps == 4)
							animate(src, alpha = 255, transform = matrix(), time = 2, loop = 1)
						total_steps ++
						if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
							accur_assist = round((step_size*total_steps)/accuracy)
							if(dir == EAST || dir == WEST) step_y += sway
							else step_x += sway
						step(src, SOUTH)
						rocketcloud()
						sleep world.tick_lag*1.5
				timeout = 0


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
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						sleep 15
						Explode(42, -50, owner)
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
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1


			molotov
				icon_state	= "molotov"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 0

				hp_modifier	= -5
				penetration	= 0
				px_range	= 75
				accuracy	= 15	// every [accuracy] pixels, the projectile will stray 1px off from true center.
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
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						drop_fire(6, owner)
						GC()
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
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1
					drop_fire(6, owner)
					GC()


			airstrike
				icon_state	= "airstrike"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4

				hp_modifier	= -5
				penetration	= 0
				px_range	= 64
				accuracy	= 8	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5
				New()
					..()
					draw_spotlight(x_os = -38, y_os = -38, hex = "#FFCC00")
				GC()
					end_step = 0
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						sleep 15
						airstrike(loc, owner)
						spawndel(5)
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
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1

			glowstick
				icon_state	= "glowstick"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4

				hp_modifier	= 0
				penetration	= 0
				px_range	= 64
				accuracy	= 4	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 1
				New()
					..()
					color = pick("#0096D6","#008080","#FF7373","#00FF00","#FF00FF")
					draw_spotlight(x_os = -38, y_os = -38, hex = color)
				GC()
					end_step = 0
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						spawndel(150)
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
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1
