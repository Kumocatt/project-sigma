proc
	fire_count(turf/t)
		//	called to count how many fire triggers are on a tile.
		if(t)
			var/count = 0
			for(var/obj/hazard/fire/f in t)
				count ++
			return count
atom/movable
	proc/drop_fire(flames = 4, mob/owner)
		/*
			called to spawn fire around a given object.
		*/
		var/list/turf_list = new /list()
		for(var/turf/t in oview(1, src))
			if(!t.density) turf_list += t
		if(turf_list.len) for(var/i = 0 to flames)
			var/turf/t = pick(turf_list)
			switch(fire_count(t))
				if(0)
				//	var/image/spotlight_r/a		= /image/spotlight_r
					var/obj/hazard/fire/f 		= garbage.Grab(/obj/hazard/fire)
					f.owner						= owner
					f.loc						= t
				//	f.overlays += a
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






obj/barricade
	barrel
		icon 			= '32x32.dmi'
		icon_state 		= "barrel"
		density 		= 1
		layer 			= TURF_LAYER+2
		step_size		= 2
		is_explosive	= 1
		d_ignore		= 0

	proc
		repop()
			set waitfor = 0
			sleep 200
			loc 		= initial(loc)
			icon_state 	= initial(icon_state)
			density 	= 1
			exploded	= 0

obj/hazard
	is_garbage	= 1
	GC()
		alpha = 255
		..()
	mine
		icon		= 'combat/_Bullets.dmi'
		icon_state	= "mine"
		is_explosive= 1
		layer		= TURF_LAYER+0.2
		bound_x		= 8
		bound_width	= 8
		bound_height= 8
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a))
				Explode(16, -150, owner, 1)
		GC()
			exploded = 0
			..()

	fire
		icon				= 'combat/_Bullets.dmi'
		icon_state			= "fire1"
		appearance_flags	= NO_CLIENT_COLOR
		plane				= 2
		bound_x				= 8
		bound_y				= 2
		bound_height		= 8
		New()
			..()
			if(prob(10))
				if(prob(50))
					icon_state = "hellfire"
					draw_spotlight(x_os = -30, y_os = -38, hex = "#FF3333")
				else
					icon_state = "fireproof"
					draw_spotlight(x_os = -30, y_os = -38, hex = "#99CCFF")
			else
				icon_state	= "fire[pick(1,2)]"
				draw_spotlight(x_os = -30, y_os = -38, hex = "#FFCC00")
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a))
				if(icon_state == "fireproof")
					a:fireproof()
				else
					if(icon_state == "hellfire")
						a:burn(,1)
					else a:burn()
			else if(istype(a, /obj/barricade))
				GC()


	puke
		icon				= 'combat/_Bullets.dmi'
		icon_state			= "puke1"
		appearance_flags	= NO_CLIENT_COLOR
		bound_x				= 8
		bound_y				= 2
		bound_height		= 8
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a)) a:slow()

	spikes
		icon		= 'combat/projectiles.dmi'
		icon_state	= "spikes-off"
		layer		= TURF_LAYER+0.2
		Crossed(atom/movable/a)
			if(icon_state == "spikes-on" && ismob(a))
				a:edit_health(-15)
			else if(ismob(a))
				sleep 5
				icon_state = "spikes-on"
				sleep 20
				icon_state = "spikes-off"
		GC()
			icon_state = "spikes-off"
			..()

	sacriportal
		icon		= 'combat/projectiles.dmi'
		icon_state	= "sacrispikes"
		layer		= TURF_LAYER+0.2
		var/tmp/bloodgained = 0
		Crossed(atom/movable/a)
			if(icon_state == "sacrispikes" && ismob(a))
				a:edit_health(-20)
				bloodgained += 20
				if(bloodgained >= 100)
					bloodgained = 0
					var/obj/hazard/portal/p = new
					p.loc = loc
					del src

	portal
		icon				= 'game/misc_effects.dmi'
		icon_state			= "portal-closed"
		appearance_flags	= NO_CLIENT_COLOR
		plane				= 2
		bound_x				= 3
		New()
			..()
			icon_state	= "portal-open"
			active_game.portals.Add(src)
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(a.can_teleport && icon_state == "portal-open")
				flick("portal-use",src)
				a:portal(owner)
				active_game.portals.Remove(src)
				icon_state = "portal-closed"
				sleep 60
				active_game.portals.Add(src)
				icon_state = "portal-open"

	boom_marker	// used to create explosions on the fly.
		is_explosive 	= 1
		exploded		= 0
var
	obj/overlays/fire/FIRE_OVERLAY			= new
	obj/overlays/shield1/SHIELD_OVERLAY1	= new
	obj/overlays/shield2/SHIELD_OVERLAY2	= new
	obj/overlays/censor_bar/CENSOR_OVERLAY	= new
	obj/overlays/cowbell/COWBELL_OVERLAY	= new
	obj/overlays/reload/RELOAD_OVERLAY		= new


obj/overlays
	fire
		icon 			= '_Bullets.dmi'
		icon_state 		= "fire1"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_x 		= -6
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR

	shield1
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield1"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	shield2
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield2"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR

	cowbell
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "cowbell"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_y 		= 32
		pixel_x			= -4
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	crown
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "crown"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_y 		= 32
		pixel_x			= -4
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	censor_bar
		icon				= 'game/misc_effects.dmi'
		icon_state			= "censorbar"
		layer				= FLOAT_LAYER
		plane				= 2
		appearance_flags	= NO_CLIENT_COLOR
	reload
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "reloading"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR


atom/movable
	var/tmp/can_teleport = 1
	proc
		portal(mob/_owner)	// make so if there is an owner, it looks for a portal with the same owner.
			set waitfor = 0
			if(can_teleport && (active_game.portals.len > 1))
				can_teleport = 0
				animate(src, alpha = 0, transform = turn(matrix(),360), color = "green", time = 5)
				sleep 5
				loc = pick(active_game.portals)
				animate(src, alpha = 255, transform = turn(matrix(),360), color = null, time = 5)
				sleep 10
				can_teleport = 1
mob
	var/tmp
		fireproof	= 0
		on_fire		= 0
		bleeding	= 0
		can_bleed	= 1
		censored	= 0
		can_censor	= 1
		shocked		= 0
		can_shock	= 1
		cowbell		= 0
		invincible	= 0
		speed_flux	= 0
		slowed		= 0
		can_slow	= 1
	proc
		burn(mob/owner, hellfire = 0)
			set waitfor = 0
			if(!on_fire && !fireproof)
				on_fire	= 1
				overlays += FIRE_OVERLAY
				animate(src, color = "#303030", time = 10, loop = -1)
				animate(color = null, time = 10, loop = -1)
				var/i 		= 0
				while(health && on_fire && !active_game.intermission && !fireproof)
					if(!hellfire && i > pick(5,12))
						break
					edit_health(-2, owner)
					drop_fire(pick(1,2), src)
					i ++
					sleep 5
				animate(src, color = null)
				overlays -= FIRE_OVERLAY
				on_fire = 0

		bleedout(time = 1, mob/owner)
			set waitfor = 0
			if(!bleeding && can_bleed)
				bleeding	= 1
				var/i 		= 0
				while(health && bleeding && !active_game.intermission)
					if(i > pick(5,12))
						break
					edit_health(-2, owner)
					i ++
					sleep 5
				bleeding = 0

		shock(time = 1, mob/owner)
			set waitfor = 0
			if(!shocked && can_shock)
				shocked	= 1
				var/i 	= 0
				while(health && shocked && !active_game.intermission)
					if(i > pick(5,12))
						break
					edit_health(-1, owner)
					if(move_disabled) move_disabled = 0
					else	move_disabled = 1
					i ++
					sleep 5
				shocked 			= 0
				move_disabled	= 0


		censor(remove = 0)
			if(!censored && can_censor)
				censored = 1
				overlays += CENSOR_OVERLAY
				if(istype(src, /mob/player))
					overlays -= src:shirt
					overlays -= src:pants
			else if(remove)
				censored = 0
				if(istype(src, /mob/player))
					overlays += src:shirt
					overlays += src:pants
				overlays -= CENSOR_OVERLAY


		fireproof()
			set waitfor = 0
			if(!fireproof)
				fireproof 	= 1
				animate(src, color = "blue", time = 10, loop = -1)
				animate(color = null, time = 10, loop = -1)
				sleep 300
				fireproof 	= 0
				animate(src, color = null, time = 10, loop = 1)

		shield(npc_shield)
			if(!has_shield)
				has_shield 	= 1
				overlays += SHIELD_OVERLAY1
		blueshield(npc_shield)
			if(!has_shield)
				has_shield 	= 2
				overlays += SHIELD_OVERLAY2

		cowbell()
			set waitfor = 0
			if(!cowbell)
				cowbell	= 1
				overlays += COWBELL_OVERLAY
				var/i 	= 0
				while(health && cowbell)
					if(i > 5) break
					i ++
					sleep 10
				cowbell = 0
				overlays -= COWBELL_OVERLAY
		slow()
			set waitfor = 0
			if(!slowed && can_slow)
				slowed	= 1
		//		overlays += SLOWED_OVERLAY
				var/i 			= 0
				var/init_stize 	= step_size
				step_size		= 1
				while(health && slowed)
					if(i > 2) break
					i ++
					sleep 10
				slowed 		= 0
				step_size	= init_stize
		//		overlays -= SLOWED_OVERLAY
		invincible(remove = 0)
			set waitfor	= 0
			if(!invincible)
				invincible 	= 1
				can_hit		= 0
				fireproof	= 1
				while(health && invincible)
					twinkle()
					sleep 5
				invincible 	= 0
				can_hit		= 1
				fireproof	= initial(fireproof)
			else if(remove)
				invincible 	= 0
				can_hit		= 1
				fireproof	= initial(fireproof)