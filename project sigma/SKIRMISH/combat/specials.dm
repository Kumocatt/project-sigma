proc
	throw_special(obj/_type, _dir)
		if(_type && _dir)
			var/obj/projectile/thrown/p 	= garbage.Grab(_type)
			p.dir							= _dir
			p.sway							= pick(-1,1)
			return p

obj
	weapon
		special

			grenade
				recharge	= 20
				drop_type	= /obj/item/special/grenade

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= throw_special(/obj/projectile/thrown/grenade, m.dir)
					if(m.client) m:flick_arms("base-grenade")
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1



/*
			shuriken
				damage		= -20
				max_range	= 64
				accuracy	= 5
				recoil		= -4	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 5
				drop_type	= /obj/item/special/shuriken

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/shuriken, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					if(m.client) m:flick_arms("base-shuriken-attack")
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1

			mine
				recharge	= 30
				drop_type	= /obj/item/special/mine

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir = m:trigger_dir
					var/obj/hazard/mine/p 	= garbage.Grab(/obj/hazard/mine)
					p.loc 		 			= m.loc
					p.owner		 			= m
					p.icon_state 			= initial(p.icon_state)
					m.move_disabled			= 0
					sleep recharge
					can_use					= 1

			molotov
				damage		= -25
				max_range	= 128
				accuracy	= 7
				recoil		= -6	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 7
				drop_type	= /obj/item/special/molotov

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/molotov, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					if(m.client) m:flick_arms("base-molotov-attack")
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1

			fireball
				damage		= -5
				max_range	= 64
				accuracy	= 15
				recoil		= -4	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 5
				drop_type	= /obj/item/special/fireball

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/fireball, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1

			firewall
				damage		= -25
				max_range	= 64
				accuracy	= 7
				recoil		= -6	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 7
				drop_type	= /obj/item/special/firewall

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/firewall, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1


			glowstick_g
				damage		= 0
				max_range	= 64
				accuracy	= 8
				recoil		= 4
				recharge	= 3
				drop_type	= /obj/item/special/glowstick_g

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/glowstick_g, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1


			glowstick_r
				damage		= 0
				max_range	= 64
				accuracy	= 8
				recoil		= 4
				recharge	= 3
				drop_type	= /obj/item/special/glowstick_r

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/glowstick_r, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1


			glowstick_b
				damage		= 0
				max_range	= 64
				accuracy	= 8
				recoil		= 4
				recharge	= 3
				drop_type	= /obj/item/special/glowstick_b

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/glowstick_b, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1



			cowbell
				damage		= 0
				max_range	= 15
				recharge	= 30
				drop_type	= /obj/item/special/cowbell

				use(mob/m)
					can_use 		= 0
					k_sound(m, SOUND_COWBELL1)
					m.cowbell()
					sleep recharge
					can_use			= 1
			quadbeam
				damage		= -15
				max_range	= 25
				accuracy	= 0
				recoil		= -4	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 10
		//		drop_type	= /obj/item/special/quadbeam

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 = get_projectile(/obj/projectile/laser2, NORTH, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p1.loc		= m.loc
					p1.step_x	= m.step_x
					p1.step_y	= m.step_y+7
					p1.owner	= m
					var/obj/projectile/p2 = get_projectile(/obj/projectile/laser2, SOUTH, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p2.loc		= m.loc
					p2.step_x	= m.step_x
					p2.step_y	= m.step_y+7
					p2.owner	= m
					var/obj/projectile/p3 = get_projectile(/obj/projectile/laser2, EAST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p3.loc		= m.loc
					p3.step_x	= m.step_x
					p3.step_y	= m.step_y+7
					p3.owner	= m
					var/obj/projectile/p4 = get_projectile(/obj/projectile/laser2, WEST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p4.loc		= m.loc
					p4.step_x	= m.step_x
					p4.step_y	= m.step_y+7
					p4.owner	= m
					active_projectiles += p1
					active_projectiles += p2
					active_projectiles += p3
					active_projectiles += p4
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1

			xbeam
				damage		= -15
				max_range	= 25
				accuracy	= 0
				recoil		= -4	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge	= 10
		//		drop_type	= /obj/item/special/quadbeam

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 = get_projectile(/obj/projectile/laser2, NORTHEAST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p1.loc		= m.loc
					p1.step_x	= m.step_x
					p1.step_y	= m.step_y+7
					p1.owner	= m
					var/obj/projectile/p2 = get_projectile(/obj/projectile/laser2, SOUTHWEST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p2.loc		= m.loc
					p2.step_x	= m.step_x
					p2.step_y	= m.step_y+7
					p2.owner	= m
					var/obj/projectile/p3 = get_projectile(/obj/projectile/laser2, SOUTHEAST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p3.loc		= m.loc
					p3.step_x	= m.step_x
					p3.step_y	= m.step_y+7
					p3.owner	= m
					var/obj/projectile/p4 = get_projectile(/obj/projectile/laser2, NORTHWEST, damage, max_range, rand(accuracy, accuracy-recoil), kb_dist, sway)
					p4.loc		= m.loc
					p4.step_x	= m.step_x
					p4.step_y	= m.step_y+7
					p4.owner	= m
					active_projectiles += p1
					active_projectiles += p2
					active_projectiles += p3
					active_projectiles += p4
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1

			dopple	// this is only meant to be used by the doppleganger but I presume it could be used for players?
				use(mob/m)
					if(istype(m, /mob/npc/hostile/doppleganger) && m:target)
						animate(m, alpha = 0, transform = matrix()*2, time = 5)
						m:skill1 = new m:target:equipped_weapon.type
						m:skill2 = new m:target:equipped_special.type
						m.overlays.Remove(m:hair)
						m:hair.icon_state = m:target:hair.icon_state
						m.overlays.Add(m:hair)
						m.overlays.Remove(m:shirt)
						m:hair.icon_state = m:target:shirt.icon_state
						m.overlays.Add(m:shirt)
						m.overlays.Remove(m:arms)
						m:arms.icon_state = "[m:target.icon_state]"
						m.overlays.Add(m:arms)
						m.overlays.Remove(m:nametag)
						m:nametag.change_text("[m:target]")
						m.overlays.Add(m:nametag)
						animate(m, alpha = 255, transform = matrix(), time = 5)
						sleep 15

			airsupport
				damage		= 0
				max_range	= 64
				accuracy	= 8
				recoil		= 4
				recharge	= 3
				drop_type	= /obj/item/special/airsupport

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= get_projectile(/obj/projectile/airsupport, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
					p.loc = m.loc
					switch(m.dir)
						if(NORTH)
							p.step_x	= m.step_x
							p.step_y	= m.step_y+16
						if(SOUTH)
							p.step_x	= m.step_x+6
							p.step_y	= m.step_y-6
						if(EAST)
							p.step_x	= m.step_x+16
							p.step_y	= m.step_y+6
						if(WEST)
							p.step_x	= m.step_x//-8
							p.step_y	= m.step_y+6
					p.owner	= m
					active_projectiles += p
					sleep recharge
					can_use = 1

					*/