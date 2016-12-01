
var
	obj/explosion_overlay/EXPLOSION_OVERLAY	= new

obj/explosion_overlay
	icon 			= 'fire.dmi'
	icon_state 		= "explosion"
	plane			= 2
	pixel_x 		= -8
	appearance_flags= NO_CLIENT_COLOR
	New()
		..()
		draw_spotlight(x_os = -30, y_os = -38, hex = "#FFCC00")


		// <--------- Procs and stuff --------->

proc
	spontaneous_explosion(turf/_loc, pk = 0, dmg = -100)	// pk = true if explosions hurt players too.
		set waitfor = 0
		if(_loc)
			var/obj/hazard/boom_marker/boom	= garbage.Grab(/obj/hazard/boom_marker)
			boom.loc						= _loc
			boom.Explode(42, dmg,,pk)



atom
	movable
		var
			is_explosive	= 0
			exploded		= 0
			explosion_proof	= 0 // 1 if the mob can't be hurt by explosions.

		proc
			Explode(blastbounds = 1, damage = -100, mob/owner, pk = 0)
				if(is_explosive && (exploded == 0 || exploded == 2))		// exploded = 2 for qeued explosions.
					exploded = 1
					overlays.Add(EXPLOSION_OVERLAY)
					for(var/i = 1 to 3)
						smoke()
					src.gs(pick('explosion1.wav','explosion2.wav'))
					drop_boom()
					icon_state 	= null
					density		= 0
					for(var/mob/m in obounds(src, blastbounds))
						m.knockback(7,get_dir(src, m))
						if(m.client) m:screenshake()
						if(!m.explosion_proof && (istype(m, /mob/npc) || (istype(m, /mob/player) && (pk || active_game.deathmatch || owner && !owner.client))) && m != src)
							spawn m.edit_health(damage, owner, 1)

					var/list/blowup_chain = new/list()
					for(var/obj/o in obounds(src, blastbounds))
						if(o.is_explosive && o.exploded == 0)		// don't re blow up qeued explosions.
							o.exploded = 2
							blowup_chain += o
						else if(istype(o, /obj/barricade/crate))
							spawn o:Break()
					if(blowup_chain.len)
						for(var/obj/b in blowup_chain)
							spawn b.Explode(blastbounds, damage, owner)
					spawn(5)
						overlays.Cut()
						if(istype(src, /obj/barricade/barrel) && !exploded)
							src:repop()
							return
						if(is_garbage)
							exploded = 0
							GC()
						else
							del src
