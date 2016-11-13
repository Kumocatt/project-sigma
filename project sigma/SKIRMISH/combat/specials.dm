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


			molotov
				recharge	= 40
				drop_type	= /obj/item/special/molotov

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= throw_special(/obj/projectile/thrown/molotov, m.dir)
					if(m.client) m:flick_arms("base-molotov")
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


			dopple
				recharge	= 50
			//	drop_type	= /obj/item/special/molotov there is no drop object for the dopple ability ; will consider.

				use(mob/m)
				//	can_use = 0
					if(istype(m, /mob/npc/hostile/doppleganger) && m:target)
						var/mob/npc/hostile/doppleganger/d = m
						animate(d, alpha = 0, transform = matrix()*2, time = 5)
						d.skill1 = new d.target:equipped_weapon.type
						d.skill2 = new d.target:equipped_special.type
						d.overlays.Remove(d.hair)
						d.hair.icon_state = d.target:hair.icon_state
						if(d.hair.icon_state == "style11" || d.hair.icon_state == "style13") d.hair.pixel_x = -5
						else d.hair.pixel_x = 0
						d.overlays.Add(d.hair)
						d.overlays.Remove(d.shirt)
						d.shirt.icon_state = d.target:shirt.icon_state
						d.overlays.Add(d.shirt)
						d.overlays.Remove(d.arms)
						d.arms.icon_state = "[d.target:arms.icon_state]"
						d.overlays.Add(d.arms)
						d.overlays.Remove(d.nametag)
						d.nametag.change_text("[d.target]")
						d.overlays.Add(d.nametag)
						animate(d, alpha = 255, transform = matrix(), time = 5)
						sleep 15

			airstrike
				recharge	= 100
				drop_type	= /obj/item/special/airstrike

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= throw_special(/obj/projectile/thrown/airstrike, m.dir)
					if(m.client) m:flick_arms("base-airstrike")
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


			quadbeam
				recharge	= 10
			//	drop_type	= /obj/item/special/airstrike

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 = get_projectile("laser2", NORTH, -15, 1.5, 120, 1, 4, 1)
					p1.loc		= m.loc
					p1.step_x	= m.step_x
					p1.step_y	= m.step_y+7
					p1.owner	= m
					var/obj/projectile/p2 = get_projectile("laser2", SOUTH, -15, 1.5, 120, 1, 4, 1)
					p2.loc		= m.loc
					p2.step_x	= m.step_x
					p2.step_y	= m.step_y+7
					p2.owner	= m
					var/obj/projectile/p3 = get_projectile("laser2", EAST, -15, 1.5, 120, 1, 4, 1)
					p3.loc		= m.loc
					p3.step_x	= m.step_x
					p3.step_y	= m.step_y+7
					p3.owner	= m
					var/obj/projectile/p4 = get_projectile("laser2", WEST, -15, 1.5, 120, 1, 4, 1)
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
				recharge	= 10
			//	drop_type	= /obj/item/special/airstrike

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 	= get_projectile("laser2", NORTHEAST, -15, 1.5, 120, 1, 4, 1)
					p1.loc					= m.loc
					p1.step_x				= m.step_x
					p1.step_y				= m.step_y+7
					p1.owner				= m
					var/obj/projectile/p2 	= get_projectile("laser2", SOUTHWEST, -15, 1.5, 120, 1, 4, 1)
					p2.loc					= m.loc
					p2.step_x				= m.step_x
					p2.step_y				= m.step_y+7
					p2.owner				= m
					var/obj/projectile/p3 	= get_projectile("laser2", SOUTHEAST, -15, 1.5, 120, 1, 4, 1)
					p3.loc					= m.loc
					p3.step_x				= m.step_x
					p3.step_y				= m.step_y+7
					p3.owner				= m
					var/obj/projectile/p4 	= get_projectile("laser2", NORTHWEST, -15, 1.5, 120, 1, 4, 1)
					p4.loc					= m.loc
					p4.step_x				= m.step_x
					p4.step_y				= m.step_y+7
					p4.owner				= m
					active_projectiles += p1
					active_projectiles += p2
					active_projectiles += p3
					active_projectiles += p4
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1

			fireball
				recharge	= 3
				drop_type	= /obj/item/special/fireball

				use(mob/m)
					can_use = 0
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir 				= m:trigger_dir
					var/obj/projectile/p 		= throw_special(/obj/projectile/thrown/fireball, m.dir)
					if(m.client) m:flick_arms("base-fireball")
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


					*/