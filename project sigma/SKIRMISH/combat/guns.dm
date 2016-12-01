
atom/movable
	proc
		drop_shell(var/shotty = 0)
			/*
				called to drop an empty shell from an arom.
				shotty = empty shotgun shell or a normal bullet casing?
			*/
			var/obj/details/shell/b		= garbage.Grab(/obj/details/shell)
			b.icon						= 'game/items.dmi'
			b.pixel_y					= 8
			b.pixel_x					= 4
			if(shotty) 	b.icon_state	= "emptyshell[rand(1,4)]"
			else		b.icon_state	= "emptybullet[rand(1,4)]"
			b.SetCenter(Cx(),Cy(),z)
			animate(b, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
			animate(pixel_y = rand(-8,8), time = 3, easing = BOUNCE_EASING)
		//	sleep 3
			if(shotty) 	k_sound(src, SOUND_SHELL1)
			else		k_sound(src, SOUND_CASING1)
			b.spawndel(300)

obj/details
	icon		= 'game/items.dmi'
	layer		= TURF_LAYER+0.18
	is_garbage	= 1

	shell



proc
	get_projectile(_state = "bullet", _dir, _damage = -1, _velocity = 1.5, _max_range = 120, _accuracy = 10, _kb_dist = 4, _sway = 1)
		if(_dir)
			/*
				figure out the nyan/laser madness stuff here.
			*/
			var/obj/projectile/p 	= garbage.Grab(/obj/projectile)
			p.icon_state			= _state
			if(active_game.laser_madness)	p.icon_state = "laser-[pick("red","blue")]"
			if(active_game.nyan_madness)	p.icon_state = "nyan"
			if(active_game.fire_madness)	p.icon_state = "firebullet"
			p.dir					= _dir
			p.hp_modifier			= _damage
			p.velocity				= _velocity
			p.px_range				= _max_range
			p.accuracy				= _accuracy
			p.kb_dist				= _kb_dist
			p.sway					= pick(_sway, _sway-(_sway*2))
			return p


mob
	var/tmp
		crit_rate	= 15		// probability of getting a critical shot.


obj
	weapon
		var/tmp
			damage				= -1	// how much damage the weapon should do.
			kb_dist				= 4		// how much knockback the weapon should do.
			recharge			= 0.2	// how long it takes before you can use the weapon again.
			can_use				= 1		// whether or not you can use the weapon.
			obj/item/drop_type			// the path for the weapon's item drop, if any.
			sound/sound_effect			// sound effect. Define these in New().
			can_strafe			= 0
			sight_range			= 10	// how many pixels ahead of the player's direction the camera should lead.
		proc/use()

		gun
			var/tmp
				max_range		= 64 	// how many PIXELS the projectile can travel before being culled.
				accuracy		= 10 	// stray 1px from center every [accuracy] pixels.
				recoil			= 0		// how much to decrease accuracy when firing erratically.
				reload_speed	= 0		// how many seconds it takes to reload.
				fire_rate		= 0		// how many shots per second. 0 for single shot.
				mag				= 0		// how many rounds are left in the current clip.
				mag_size		= 0		// how many rounds the weapon can hold at once.
				piercing		= 0		// how likely (in %) will the projectile pierce through hit target.
				weight			= 0		// slows movement speed  the higher this value
				crit_chance		= 0		// chance for a critical shot.
				sway			= 1		// used to determine which way projectiles should deviate towards.
				velocity		= 1.5	// used to determine how fast projectiles are.

			proc
				reload(mob/reloader)
					/* called to reload the weapon.
					*/
					if(mag < mag_size)
						if(reloader.client) reloader:reloading = 1
						if(reloader) reloader.overlays.Add(RELOAD_OVERLAY)
						for(var/i in 1 to mag_size)
							if(mag >= mag_size) break
							mag ++
							sleep reload_speed/mag_size
						if(reloader.client) reloader << SOUND_RELOAD
						if(reloader) reloader.overlays.Remove(RELOAD_OVERLAY)
						if(reloader.client) reloader:reloading = 0


			pistol
				damage				= -5
				max_range			= 120
				accuracy			= 25
				recoil				= -2
				reload_speed		= 6
				mag					= 11
				mag_size			= 11
				piercing			= 5
				weight				= 2
				crit_chance			= 30
				drop_type			= /obj/item/gun/pistol

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						var/obj/projectile/p 		= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
						if(m.client) m:flick_arms("base-pistol-attack")
						m.drop_shell()
						m.gs('gunshot1.wav')
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			kobra
				damage				= -15
				max_range			= 200
				accuracy			= 15
				recoil				= -2
				reload_speed		= 12
				mag					= 6
				mag_size			= 6
				piercing			= 75
				weight				= 1
				crit_chance			= 30
				velocity			= 0.5
				drop_type			= /obj/item/gun/kobra

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						var/obj/projectile/p 		= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
						if(m.client) m:flick_arms("base-kobra-attack")
						m.drop_shell()
						m.gs('gunshot1.wav')
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			edge_lord
				damage				= -12
				max_range			= 300
				accuracy			= 30
				recoil				= -2
				reload_speed		= 10
				mag					= 12
				mag_size			= 12
				piercing			= 0
				weight				= 1
				crit_chance			= 44
				velocity			= 0.5
				drop_type			= /obj/item/gun/edge_lord

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						var/obj/projectile/p 		= get_projectile("laser-red", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
						if(m.client) m:flick_arms("base-3dg3-10rd-attack")
						m.gs('laser1.wav')
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			pink_dream
				damage				= -20
				max_range			= 300
				accuracy			= 25
				recoil				= -2
				reload_speed		= 6
				mag					= 10
				mag_size			= 10
				piercing			= 0
				weight				= 1
				crit_chance			= 22
				velocity			= 0.5
				drop_type			= /obj/item/gun/pink_dream

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						var/obj/projectile/p 		= get_projectile("laser-pink", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
						if(m.client) m:flick_arms("base-pinkdream-attack")
						m.gs('laser1.wav')
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			ak66
				damage				= -10
				max_range			= 145
				accuracy			= 30
				recoil				= -2
				reload_speed		= 12
				fire_rate			= 60
				mag					= 15
				mag_size			= 15
				piercing			= 35
				weight				= 1.5
				crit_chance			= 15
				velocity			= 0.3
				can_strafe			= 1
				drop_type			= /obj/item/gun/ak66

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						var/i = 0 // since the gun fires in 3 round bursts we need a var to track shots
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag || (m.client && !m:trigger_down)) break
							mag --
							i ++
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
							if(m.client) m:flick_arms("base-ak66-attack")
							m.drop_shell()
							m.gs('gunshot2.wav')
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							if(i >= 3)
								sleep 5
								i = 0
							sleep world.tick_lag*0.2
						if(m.move_disabled) sleep;m.move_disabled = 0
					can_use = 1

			krossbow
				damage				= -30
				max_range			= 128
				accuracy			= 5
				recoil				= -1
				reload_speed		= 5
				mag					= 1
				mag_size			= 1
				piercing			= 95
				weight				= 1.2
				crit_chance			= 45
				velocity			= 0.2
				drop_type			= /obj/item/gun/krossbow

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						var/obj/projectile/p 		= get_projectile("bolt", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
						if(m.client) m:flick_arms("base-krossbow-attack")
						m.gs('crossbow1.ogg')
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			uzi
				damage				= -10
				max_range			= 244
				accuracy			= 10
				recoil				= -2
				reload_speed		= 24
				fire_rate			= 90
				mag					= 24
				mag_size			= 24
				piercing			= 22
				weight				= 1.5
				crit_chance			= 5
				velocity			= 0.02
				can_strafe			= 1
				drop_type			= /obj/item/gun/uzi

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
							if(m.client) m:flick_arms("base-uzi-attack")
							m.drop_shell()
							m.gs('gunshot2.wav')
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							sleep world.tick_lag*0.2 //10/fire_rate
						if(m.move_disabled) sleep;m.move_disabled = 0
					can_use = 1


			red_baron
				damage				= -15
				max_range			= 266
				accuracy			= 30
				recoil				= -2
				reload_speed		= 25
				fire_rate			= 60
				mag					= 45
				mag_size			= 45
				piercing			= 44
				weight				= 1.5
				crit_chance			= 55
				velocity			= 0.2
				can_strafe			= 1
				drop_type			= /obj/item/gun/red_baron

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+2), kb_dist, sway)
							if(m.client) m:flick_arms("base-redbaron-attack")
							m.drop_shell()
							m.gs('gunshot1.wav')
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							sleep 10/fire_rate
						if(m.move_disabled) sleep;m.move_disabled = 0
					can_use = 1

			shotgun
				damage				= -45
				max_range			= 82
				accuracy			= 1
				recoil				= -5
				reload_speed		= 6
				mag					= 2
				mag_size			= 2
				piercing			= 0
				weight				= 1
				crit_chance			= 10
				velocity			= 0.2
				drop_type			= /obj/item/gun/shotgun

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						if(m.client) m:flick_arms("base-shotgun-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						var/_dir = m.dir
						for(var/i = 1 to 4)
							var/obj/projectile/p 	= get_projectile("bullet", _dir, damage, velocity, max_range, rand(accuracy, accuracy+25), kb_dist, 2)
							p.loc 					= m.loc
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
								p.is_crit = 1
							active_projectiles += p
						//	sleep world.tick_lag/2
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			hellsredeemer
				damage				= -55
				max_range			= 60
				accuracy			= 1
				recoil				= -5
				reload_speed		= 25
				mag					= 3
				mag_size			= 3
				piercing			= 0
				weight				= 1
				crit_chance			= 10
				velocity			= 1.5
				drop_type			= /obj/item/gun/hellsredeemer

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						if(m.client) m:flick_arms("base-hellredeemer-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						for(var/i = 1 to 5)
							var/obj/projectile/p 	= get_projectile("firebullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+25), kb_dist, 2)
							p.loc 					= m.loc
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
								p.is_crit = 1
							active_projectiles += p
							sleep world.tick_lag/2
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1



			flamethrower
				damage				= -8
				max_range			= 128
				accuracy			= 4
				recoil				= -1
				reload_speed		= 15
				fire_rate			= 60
				mag					= 66
				mag_size			= 66
				piercing			= 0
				weight				= 1.5
				crit_chance			= 44
				velocity			= 0.2
				can_strafe			= 1
				drop_type			= /obj/item/gun/flamethrower

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						var/acc = 0
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("fireball", m.dir, damage, velocity, max_range, accuracy, 0, (acc>3 ? -1 : 1))
							if(m.client) m:flick_arms("base-flamethrower-attack")
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							if(acc >= 6) acc --
							if(acc <= 1) acc ++
							sleep 10/fire_rate
						if(m.move_disabled) sleep;m.move_disabled = 0
					can_use = 1


			spas_12
				damage				= -30
				max_range			= 96
				accuracy			= 1
				recoil				= -5
				reload_speed		= 10
				mag					= 5
				mag_size			= 5
				piercing			= 0
				weight				= 1
				crit_chance			= 10
				velocity			= 0.2
				drop_type			= /obj/item/gun/spas_12

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
						mag --
						if(m.client) m:flick_arms("base-spas12-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						var/_dir = m.dir
						for(var/i = 1 to 4)
							var/obj/projectile/p 	= get_projectile("bullet", _dir, damage, velocity, max_range, rand(accuracy, accuracy+25), kb_dist, 2)
							p.loc 					= m.loc
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
								p.is_crit = 1
							active_projectiles += p
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1





/*


			force_palm
				damage				= -25
				max_range			= 64
				accuracy			= 2
				recoil				= -1
				reload_speed		= 5
				mag					= 1
				mag_size			= 1
				piercing			= 0
				weight				= 0
				crit_chance			= 15
				drop_type			= /obj/item/gun/force_palm

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
							m:camera_pos()
						mag --
						var/obj/projectile/p 		= get_projectile(/obj/projectile/fblast, damage, round(max_range/6), accuracy, kb_dist, sway)
						if(m.client) m:flick_arms("base-fpalm-attack")
				//		m.drop_shell()
				//		k_sound(m, sound_effect)
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1


			impact_launcher
				damage				= -200
				max_range			= 100
				accuracy			= 4
				recoil				= -5
				reload_speed		= 25
				mag					= 1
				mag_size			= 1
				piercing			= 0
				weight				= 8
				crit_chance			= 0
				sight_range			= 15
				drop_type			= /obj/item/gun/launcher

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
							m:camera_pos()
						mag --
						var/obj/projectile/p 		= get_projectile(/obj/projectile/launcher, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
						if(m.client) m:flick_arms("base-launcher-attack")
				//		m.drop_shell()
				//		k_sound(m, sound_effect)
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1

			revolver
				damage				= -15
				max_range			= 76
				accuracy			= 7
				recoil				= -3
				reload_speed		= 15
				mag					= 6
				mag_size			= 6
				piercing			= 65
				weight				= 3
				crit_chance			= 35
				drop_type			= /obj/item/gun/revolver

				New()
					..()
					sound_effect	= SOUND_GUNFIRE1

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
							m:camera_pos()
						mag --
						var/obj/projectile/p 		= get_projectile(/obj/projectile/bullet, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
						if(m.client) m:flick_arms("base-revolver-attack")
						m.drop_shell()
						k_sound(m, sound_effect)
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1





			LB01
				damage				= -10
				max_range			= 306
				accuracy			= 100
				recoil				= -3
				reload_speed		= 13
				mag					= 13
				mag_size			= 13
				piercing			= 0
				weight				= 5
				crit_chance			= 55
				drop_type			= /obj/item/gun/LB01

				New()
					..()
					sound_effect	= SOUND_LASER1

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
								m.move_disabled		= 1
							m:camera_pos()
						mag --
						var/obj/projectile/p 		= get_projectile(/obj/projectile/laser, m.dir, damage, round(max_range/6), accuracy, kb_dist, sway)
						if(m.client) m:flick_arms("base-lb01-attack")
			//			m.drop_shell()
						k_sound(m, sound_effect)
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
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p.is_crit = 1
						active_projectiles += p
						sleep
						if(m.move_disabled) m.move_disabled = 0
					can_use = 1



			LB02
				damage				= -10
				max_range			= 306
				accuracy			= 10
				recoil				= -3
				reload_speed		= 13
				mag					= 13
				mag_size			= 13
				piercing			= 0
				weight				= 5
				crit_chance			= 55
				drop_type			= /obj/item/gun/LB02

				New()
					..()
					sound_effect	= SOUND_LASER1

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
				//				m.move_disabled		= 1
							m:camera_pos()
						mag --
						var/obj/projectile/p1 		= get_projectile(/obj/projectile/laser, m.dir, damage, round(max_range/6), 10, kb_dist, sway)
						var/obj/projectile/p2 		= get_projectile(/obj/projectile/laser, m.dir, damage, round(max_range/6), 5, kb_dist, -1)
						var/obj/projectile/p3 		= get_projectile(/obj/projectile/laser, m.dir, damage, round(max_range/6), 5, kb_dist, 1)
						if(m.client) m:flick_arms("base-lb02-attack")
			//			m.drop_shell()
						k_sound(m, sound_effect)
						p1.loc = m.loc
						p2.loc = m.loc
						p3.loc = m.loc
						switch(m.dir)
							if(NORTH)
								p1.step_x	= m.step_x
								p1.step_y	= m.step_y+16
								p2.step_x	= m.step_x
								p2.step_y	= m.step_y+16
								p3.step_x	= m.step_x
								p3.step_y	= m.step_y+16
							if(SOUTH)
								p1.step_x	= m.step_x+6
								p1.step_y	= m.step_y-6
								p2.step_x	= m.step_x+6
								p2.step_y	= m.step_y-6
								p3.step_x	= m.step_x+6
								p3.step_y	= m.step_y-6
							if(EAST)
								p1.step_x	= m.step_x+16
								p1.step_y	= m.step_y+6
								p2.step_x	= m.step_x+16
								p2.step_y	= m.step_y+6
								p3.step_x	= m.step_x+16
								p3.step_y	= m.step_y+6
							if(WEST)
								p1.step_x	= m.step_x-8
								p1.step_y	= m.step_y+6
								p2.step_x	= m.step_x-8
								p2.step_y	= m.step_y+6
								p3.step_x	= m.step_x-8
								p3.step_y	= m.step_y+6
						p1.owner	= m
						p2.owner	= m
						p3.owner	= m
						if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
							p1.is_crit = 1
						active_projectiles += p1
						active_projectiles += p2
						active_projectiles += p3
						sleep
				//		if(m.move_disabled) m.move_disabled = 0
					can_use = 1


			flamethrower
				damage				= -35
				max_range			= 128
				accuracy			= 4
				recoil				= -2
				reload_speed		= 15
				mag					= 66
				mag_size			= 66
				fire_rate			= 60
				piercing			= 0
				weight				= 4
				crit_chance			= 10
				can_strafe			= 1
				sight_range			= 5
				drop_type			= /obj/item/gun/flamethrower

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
							m:camera_pos()
						var/acc = 0
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							var/obj/projectile/p 	= get_projectile(/obj/projectile/fireball, m.dir, damage, round(max_range/6), acc, kb_dist, (acc>3 ? -1 : 1))
							if(m.client) m:flick_arms("base-flamethrower-attack")
						//	m.drop_shell()
						//	k_sound(m, sound_effect)
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
								p.is_crit = 1
							active_projectiles += p
							if(acc >= 6) acc --
							if(acc <= 1) acc ++
							sleep 10/fire_rate
				//	if(m.move_disabled) m.move_disabled = 0
					can_use = 1


			sk47
				damage				= -15
				max_range			= 244
				accuracy			= 10
				recoil				= -2
				reload_speed		= 27
				mag					= 44
				mag_size			= 44
				fire_rate			= 44
				piercing			= 44
				weight				= 4
				crit_chance			= 14
				can_strafe			= 1
				sight_range			= 30
				drop_type			= /obj/item/gun/sk47

				use(mob/m)
					can_use = 0
					if(!mag)
						// add the reloading overlay.
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
							m:camera_pos()
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							var/obj/projectile/p 	= get_projectile(/obj/projectile/laser3, m.dir, damage, round(max_range/6), rand(accuracy, accuracy+5), kb_dist, sway)
							if(m.client) m:flick_arms("base-sk47-attack")
						//	m.drop_shell()
							k_sound(m, sound_effect)
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
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							p.owner	= m
							if(prob(m.crit_rate+crit_chance))	// add the player and the weapon's crit chances.
								p.is_crit = 1
							active_projectiles += p
							sleep 10/fire_rate
				//	if(m.move_disabled) m.move_disabled = 0
					can_use = 1



	/*
			portalgun
				damage				= -5
				max_range			= 45
				accuracy			= 3
				recoil				= -2	// how many points each consecutive shot will take away from the player's accuracy offset.
				recharge			= 2.5
				barrel_point		= 7
				drop_type			= /obj/item/gun/portalgun
				New()
					..()
					sound_effect	= SOUND_LASER1

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					if(m.client)
						if(m.dir != m:trigger_dir)
							sleep world.tick_lag*2
							m.dir = m:trigger_dir
					var/obj/projectile/p 	= get_projectile(/obj/projectile/laser, m.dir, damage, max_range, rand(accuracy, accuracy-recoil*m.acc_offset), kb_step, kb_dist, sway)
					if(m.client) m:flick_arms("base-lb01-attack")
					k_sound(m, sound_effect)
					p.loc		= m.loc
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
							p.step_x	= m.step_x-8
							p.step_y	= m.step_y+6
					p.owner		= m
					if(prob(m.crit_rate)) p.is_crit = 1
					m.acc_offset += recoil
					active_projectiles += p
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1
					sleep recharge
					m.acc_offset -= recoil

					*/


					*/