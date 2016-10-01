
var
	tmp
		list/ai_list	= new/list()


proc
	ai_loop()
		set waitfor = 0
		for()
			if(ai_list.len) for(var/mob/npc/m in ai_list)
				m.ai_check()
			sleep world.tick_lag


mob/npc
	is_garbage		= 1
	bound_height	= 20
	var/tmp
		resting		= 0
		ig_bump		= 0
		auto_target	= 1	// 1 if the mob should automatically target the nearest player.
		mob/target
		has_spotlight 	= 1
		can_phantom		= 1	// 0 if the enemy is immune to phantom status
	proc
		ai_check()
			/*
				this is where you add the npcs behavior.
			*/
		drop_loot()
			var/obj/item/drop_this	= get_drop()
			if(drop_this)
				var/obj/_drop 	= garbage.Grab(drop_this)
				_drop.loc 		= loc
				_drop.spawndel(600)

		respawn()
			var/obj/_loc 		= pick(active_game.enemy_spawns)
			var/mob/player/p	= pick(active_game.participants)
			for(var/obj/markers/enemy_spawn/espawn in oview(p, 45))
				_loc = espawn
				break
			loc = _loc.loc



	Bump(atom/a)
		if(kb_init)
			kb_init = 0
			if(istype(a, /mob/player) || istype(a, /mob/npc))
				a:knockback(6, get_dir(src, a))
		if(istype(a, /obj/barricade))
			var/obj/barricade/b = a
			if((kb_init || istype(src, /mob/npc/hostile/brute)) && istype(b, /obj/barricade/crate))
				b:Break()
			else
				b.last_pusher = src
				step(b, dir)
		if(!ig_bump && target && world.cpu < 60)
			ig_bump = 1
			step_to(src, target)
			ig_bump = 0
	hostile
		var/tmp
			mob/player/last_attacker
			turf/last_loc
			same_loc_steps	// how many times the mob has been stuck in the same tile.

		New()
			..()
			if(has_spotlight) draw_spotlight(x_os = -30, y_os = -38, hex = "#FF3333")
		GC()
			..()
			if(censored) censor(1)
			animate(src, 0)
			density			= 1
			alpha			= 255
			last_attacker	= null
			if(targeted)
				for(var/mob/player/p in active_game.participants)
					p.remove_target(src)
				targeted = 0


		death()
//			world << "check?"
			ai_list -= src
			if(last_attacker) last_attacker.kills ++
			..()
			active_game.enemies_left --
			if(prob(15)) drop_loot()
			if(is_explosive) // if is_explosive is toggled on for the mob, that means to blow it up when it dies!
				is_explosive = 0
				spontaneous_explosion(loc, 1, 45)
			GC()
			active_game.progress_check()


		feeder
			icon			= 'enemies/_Zombie.dmi'
			icon_state		= "grey"
			density			= 1
			step_size		= 4
			base_health		= 10

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? rand(2,4)+speed_fluxer : rand(2,4))
					resting = 0
		puker
			icon			= 'enemies/_Puker.dmi'
			icon_state		= "blue"
			density			= 1
			step_size		= 3
			base_health		= 15
			can_slow		= 0

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
				//	if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(prob(1))
						flick("[icon_state]-attack", src)
						var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
						f.loc					= loc
						f.step_x				= step_x-8
						f.step_y				= step_y-8
						f.spawndel(150)
						sleep 10
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
						//		target.knockback(6, step_dir)
								target.edit_health(-5)
								var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
								f.loc					= target.loc
								f.step_x				= target.step_x-8
								f.step_y				= target.step_y-8
								f.spawndel(150)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? rand(2,4)+speed_fluxer : rand(2,4))
					resting = 0

		crawler
			icon			= 'enemies/_Crawler.dmi'
			icon_state		= "grey"
			density			= 1
			step_size		= 5
			base_health		= 15

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								if(prob(get_dist(src, target)))
									for(var/i = 1 to 6)
										dust()
										step(src, step_dir, step_size+2)
										sleep world.tick_lag
								else
									step(src, step_dir)
									if(last_loc == loc)
										same_loc_steps ++
										if(same_loc_steps > 10)
											. = 1
											for(var/mob/player/p in active_game.participants)
												if(get_dist(p, src) < 25) . = 0; break
											if(.) same_loc_steps = 0; respawn()
									else
										last_loc 		= loc
										same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? 2+speed_fluxer : 2)
					resting = 0

		brute
			icon			= 'enemies/_Brute.dmi'
			icon_state		= "brute"
			density			= 1
			step_size		= 3
			base_health		= 30
			can_kb			= 0

			ai_check()
				set waitfor = 0
				if(health && !resting)
					resting = 1
				//	if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(10, step_dir)	// massive knockback from brutes.
								target.edit_health(-30)
								sleep 10
							else
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? rand(2,4)+speed_fluxer : rand(2,4))
					resting = 0
			Bump(atom/a)
				if(istype(a, /mob/npc/hostile))
					var/mob/b = a
					b.knockback(5, turn(dir, pick(-45,45)))
				..()



		beholder
			icon			= 'enemies/beholder.dmi'
			icon_state		= "beholder"
			density			= 1
			step_size		= 2
			base_health		= 20
			fireproof		= 1
			can_censor		= 0
			var/obj/weapon/special/skill1 //= new /obj/weapon/special/fireball

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-2)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && shot_lineup())
								dir = get_dir(src, target)
								skill1.use(src)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? 2+speed_fluxer : 2)
					resting = 0


		abstract
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract1"
			density			= 1
			step_size		= 2
			base_health		= 5
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 0
			var/obj/weapon/special/skill1 //= new /obj/weapon/special/quadbeam

			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#FF3333")
			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && shot_lineup())
								dir = get_dir(src, target)
								flick("abstract1-attack", src)
								sleep 8
								skill1.use(src)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? 2+speed_fluxer : 2)
					resting = 0
			death()
				skill1.use(src)
				..()

		abstract2
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract2"
			density			= 1
			step_size		= 4
			base_health		= 5
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 0
			var/obj/weapon/special/skill1 //= //new /obj/weapon/special/xbeam

			New()
				..()
				draw_spotlight(x_os = -38, y_os = -38, hex = "#FF3333")

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && diag_lineup())
								dir = get_dir(src, target)
								flick("abstract2-attack", src)
								sleep 8
								skill1.use(src)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 10)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 25) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*(active_game.speed_flux ? 2+speed_fluxer : 2)
					resting = 0
			death()
				skill1.use(src)
				..()


		doppleganger
			icon			= 'enemies/doppleganger.dmi'
			icon_state		= "dopple1-"
			density			= 1
			step_size		= 2
			base_health		= 250
			can_censor		= 0
			appearance_flags= KEEP_TOGETHER
			is_garbage		= 0
			plane			= 0
			explosion_proof	= 1
			has_spotlight	= 0
			var/obj/weapon/gun/skill1 		= new /obj/weapon/gun/pistol
			var/obj/weapon/special/skill2 //	= new /obj/weapon/special/molotov
			var/obj/weapon/special/skill3//	= new /obj/weapon/special/dopple
			var/tmp
				obj/arms 	= new /obj/player/arms
				obj/shirt	= new /obj/player/shirt
				obj/pants	= new /obj/player/pants
				obj/hair 	= new /obj/player/hair
			New()
				..()
				overlays += /image/spotlight
			death()
				ai_list -= src
				for(var/mob/player/c in active_game.participants)
					c.client.eye = src
					spawn(30)
						c.client.eye = c
				for(var/i = 1 to 35)
					step(src, dir)
					if(prob(25)) {spontaneous_explosion(loc, 0); dir = turn(dir,pick(-45,45))}
					sleep world.tick_lag*1.5

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
										skill3.use(src)

							if(bounds_dist(src, target) <= 2)
								target.knockback(8, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 9 && skill1.can_use && shot_lineup())
								dir = get_dir(src, target)
						//		flick("dopple-attack", src)
								skill1.use(src)
								sleep 5
							else if(get_dist(src, target) < 4 && skill2.can_use && shot_lineup() && prob(45))
								dir = get_dir(src, target)
								skill2.use(src)
							else if(!kb_init)
								step(src, step_dir)
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc) continue
							if(!target)
								target = p
								skill3.use(src)
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
								skill3.use(src)
					sleep world.tick_lag*2.5
					resting = 0
			proc
				flick_arms(fstate = "base-")
					set waitfor = 0
					var/ogstate = arms.icon_state
					overlays -= arms
					arms.icon_state = "[fstate]"
					overlays += arms
					sleep 1
					overlays -= arms
					arms.icon_state = "[ogstate]"
					overlays += arms

		hellbat
			icon			= 'enemies/hellbat.dmi'
			icon_state		= "hellbat"
			density			= 1
			step_size		= 4
			base_health		= 5
			fireproof		= 1
			explosion_proof	= 1
			can_censor		= 0
			bound_x			= 8
			bound_y			= 8
			has_spotlight	= 0
			can_phantom		= 0
			var/tmp/flying	= 0

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(!flying)
						flying		= 1
						can_hit		= 0
						density		= 0
						animate(src, pixel_y = 32, alpha = 55, transform = matrix(), time = 10, easing = ELASTIC_EASING)
						sleep 10
					if(target)
						if(!target.health || target.cowbell || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/player/p in active_game.participants)	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
							if(bounds_dist(src, target) <= 4 && flying)
								sleep 5
								flying 		= 0
								can_hit		= 1
								icon_state	= "hellbat-attack"
								animate(src, pixel_y = 0, alpha = 255, transform = transform/2, time = 5, easing = BOUNCE_EASING)
								density	= 1
								sleep 3
								if(target in obounds(src, 4))
									target.knockback(6, step_dir)
									target.edit_health(-10)
								icon_state	= "hellbat"
								sleep 20
							else if(!kb_init)
								step(src, step_dir)
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*2
					resting = 0




	proc
		shot_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					// if tiles are lined up, line up the pixel coordinates!
					if(NORTH, SOUTH)
						if(target.step_x > step_x)	// target is further right on the tile than src.
							step(src, EAST, 8)
						else
							step(src, WEST, 8)
						return 1
					if(EAST, WEST)
						if(target.step_y > step_y)	// target is further north on the tile than src.
							step(src, NORTH, 8)
						else
							step(src, SOUTH, 8)
						return 1
				// otherwise, line up tiles.
					if(NORTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag*2
					if(NORTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag*2
					if(SOUTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag*2
					if(SOUTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag*2
			return 0



		diag_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					if(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						return 1
					else return 0