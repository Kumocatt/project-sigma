

var
	tmp
		list/support_ai	= new /list()
		list/res_ai		= new /list()


proc
	support_loop()
		set waitfor = 0
		for()
			if(support_ai.len) for(var/mob/npc/m in support_ai)
				m.ai_check()
			sleep world.tick_lag

	ressurect_ai()
		set waitfor = 0
		if(res_ai.len) for(var/mob/npc/support/m in res_ai)
			m.health		= m.base_health
			m.transform		= matrix()
			m.density 		= 1
			m.loc			= pick(active_game.player_spawns)
			m.move_disabled = 0
			m.alpha			= 255
			m.alive			= 1
			support_ai += m
			res_ai -= m
			world << ">> [m] was revived!"


mob
	var/tmp/pvp_on	= 0
	npc
		support
			explosion_proof	= 1
			var/tmp
				mob/last_attacker
				mob/closest_friend
				turf/last_loc
				same_loc_steps		 // how many times the mob has been stuck in the same tile.
				alive			= 0
				namecolor		= "#FFFFFF"
				awareness		= 55 // how likely the npc will check its surroundings. High probability will make the npc more aware of it's surroundings.
				target_range	= 15
				pushing			= 0
			New()
				..()
				if(has_spotlight) draw_spotlight(x_os = -30, y_os = -38, hex = "#FFFFFF")
			Bump(atom/a)
				..()
				if(kb_init)
					kb_init = 0
					if(istype(a, /mob/player) || istype(a, /mob/npc))
						a:knockback(6, get_dir(src, a))
					if(istype(a, /obj/barricade/crate))
						var/obj/barricade/crate/c = a
						c.Break()
				if(istype(a, /obj/barricade) && !a:broken && !pushing)
					pushing 				= 1
					var/obj/barricade/b 	= a
					b.last_pusher 			= src
					var/tmp/list/push_group	= new/list()
					push_group += b
					. = b
					top
					if(push_group.len < 3) for(var/obj/barricade/c in bounds(., 1))
						if(get_dir(.,c) == dir)
							c.last_pusher = src
							push_group += c
							. = c
							goto top
					if(push_group.len > 1)
						while(push_group.len)
							var/obj/barricade/d = push_group[push_group.len]
							if(step(d, dir)) spawn d.dust()
							push_group.Remove(d)
					else if(step(b, dir)) spawn b.dust()
					pushing = 0
				if(ismob(a))
					a:knockback(4, get_dir(src, a))
					if(on_fire) a:burn()
				if(!ig_bump && (closest_friend || target) && world.cpu < 60)
					ig_bump = 1
					if(target) step_to(src, target, 0,0)
					else if(closest_friend) step_to(src, closest_friend, 0,0)
					ig_bump = 0

			GC()
				..()
				if(censored) censor(1)
				animate(src, 0)
				density			= 1
				alpha			= 255
				last_attacker	= null
				transform		= matrix()
				step_size		= initial(step_size)
				if(targeted)
					for(var/mob/player/p in active_game.participants)
						p.remove_target(src)
					targeted = 0

			death()
				if(alive)
					alive = 0
					support_ai -= src
					res_ai += src
					if(targeted)
						for(var/mob/player/p in active_game.participants)
							p.remove_target(src)
						targeted = 0
					density = 0
					death_animation()
					sleep 5
					remove_spectators()
					if(censored)	censor(1)
					loc				= locate(1,1,1)
					move_disabled 	= 1
					alpha			= 0
					world << "<b><font color = [namecolor]>[src]</font> died! ([kills] kills)"
					active_game.participants << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
					active_game.spectators << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
					active_game.progress_check()



			///////////  ai for support npcs should be fairly complicated. i want them to be able to recognize their surroundings and react to potential explosives, traps, afire, etc.
			//////////////	different npcs will of course have different weapons and loadouts and behaviors. Some npcs will be more prone to hanging around
			//////////////	the acctive players and providing assising cover while others moreso just go about and attack every enemy it can.
			//////////////	some support npcs should be better and worse than others beit through poor ai behavcior pattersns or loadout types. This will
			//////////////	promote variety in reliability of npcs to know when one will be more helpful for reaching later waved.
			//////////////
			//////////////	some support npcs will also join randomly during some waves while others will need to be defended to survive/pass the wave.



			kett		// there will be different support npcs with their own appearance/loadout/ai and each game will spawn with a randomly chosen one.
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 4
				base_health		= 150
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 0
				plane			= 0
				pvp_on			= 0

				awareness		= 95
				target_range	= 20
				var/obj/weapon/gun/skill1 		= new /obj/weapon/gun/uzi
				var/obj/weapon/special/skill2 	= new /obj/weapon/special/airstrike
				var/obj/weapon/special/skill3	= new /obj/weapon/special/glowsticks
				var/tmp
					obj/arms 			= new /obj/player/arms
					obj/shirt			= new /obj/player/shirt
					obj/pants			= new /obj/player/pants
					obj/hair 			= new /obj/player/hair
					obj/vanity			= new /obj/player/vanity


				ai_check()
					set waitfor = 0
					if(alive && !resting && !kb_init)
						resting = 1
						if(prob(awareness)) // if they're highly alert, check for hazards(or targets).
							// first let's check for enemies..
							if(target)	// if kett already has a target..
								var/targ_dist	= get_dist(src, target)
								if(prob(targ_dist*5)) for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc || h == target) continue
									if(get_dist(src, h) <= targ_dist)
										target = h
							else // if kett does not have a target..
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc) continue
									if(get_dist(src, h) <= target_range)
										target = h
							for(var/mob/player/p in active_game.participants)
								if(!p.health || !p.loc || p.died_already) continue
								if(closest_friend)
									if(get_dist(src, p) < get_dist(src, closest_friend))
										closest_friend = p
								else
									closest_friend = p
			//		<-----------------------------------------------------------------------------------
						if(target)
							if(!target.health || !target.loc || get_dist(src, target) > target_range)
								target = null
							else
								var/targ_dist 	= get_dist(src, target)
								var/targ_dir	= get_dir(src, target)
							/* if kett still has a target in range, we need to figure out how to engage.
							if super close, we'll want kett to push the enemy away a few steps by simply bumping into them(like players can do).
						if a few tiles away, but still in sight we can shoot at them.
						if still in range, but can't use our gun for some reason, kett will throw a molotov! */
								if(targ_dist <= 1) // if the target is within a tile away, bump them away!
									if(target.type != /mob/npc/hostile/brute)
										for(var/i = 1, i < 3, i++)			// if super close, bump enemies away, unless they're a brute, ofc
											step(src, targ_dir)
											sleep world.tick_lag
									step_away(src, target)
									sleep world.tick_lag
								if(targ_dist < 4) // if target is three tiles or less away, make some room!
									step_away(src, target)
									sleep world.tick_lag
								if(targ_dist > 2 && targ_dist < 7)
									if(skill1.can_use && shot_lineup())
										dir = get_general_dir(src, target)
										spawn skill1.use(src)
										sleep world.tick_lag
									else if(skill2.can_use && prob(15) && shot_lineup())
										dir = get_general_dir(src, target)
										spawn skill2.use(src)
										sleep world.tick_lag
								if(targ_dist > 5)
									if(targ_dist > 10 && prob(35))
										for(var/i = 1 to 4)
											dust()
											step(src, targ_dir, step_size+2)
											sleep world.tick_lag
									else
										step(src, pick(targ_dir, turn(targ_dir,pick(-45,45))))
										sleep world.tick_lag
						if(!target)
							if(closest_friend)
								if(!closest_friend.health || !closest_friend.loc)
									closest_friend = null
								else
									var/friend_dist = get_dist(src, closest_friend)
									if(friend_dist > 5 && prob(30))
										for(var/i = 1 to 4)
											dust()
											step(src, get_dir(src, closest_friend), step_size+2)
											sleep world.tick_lag
									else if(friend_dist >= 3)
										step_towards(src, closest_friend)
										sleep world.tick_lag
									if(friend_dist <= 2)
										sleep 5
							else
								step_rand(src)
								sleep world.tick_lag
						if(!active_game.intermission && skill3.can_use && prob(2))
							spawn skill3.use(src)
						sleep world.tick_lag*1.5
						resting = 0

			// <------------------------------------------------------------------------------------

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