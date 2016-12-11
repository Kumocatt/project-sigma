
proc
	get_drop()
		var/obj/item/drop_this = /obj/item/health_pack
		switch(rand(1,3))
			if(1) // tier one items
				drop_this 			= pick( /obj/item/health_pack, /obj/item/gun/kobra, /obj/item/special/molotov, /obj/item/shield_tier1, /obj/item/special/glowsticks, \
											/obj/item/gun/shotgun, /obj/item/gun/ak66, /obj/item/special/grenade )
			if(2)
				if(prob(75))
					drop_this 		= pick( /obj/item/health_pack, /obj/item/gun/edge_lord, /obj/item/gun/spas_12, /obj/item/shield_tier2, /obj/item/gun/krossbow,\
											/obj/item/gun/pink_dream, /obj/item/special/fireball, /obj/item/special/cowbell, /obj/item/gun/uzi )
			if(3)
				if(prob(50))
					drop_this		= pick( /obj/item/revive_pack, /obj/item/shield_tier3, /obj/item/special/airstrike, /obj/item/gun/hellsredeemer, \
											/obj/item/gun/flamethrower, /obj/item/gun/red_baron )
		return drop_this



obj
	item
		icon				= 'items.dmi'
		is_garbage			= 1
		appearance_flags	= NO_CLIENT_COLOR
		layer				= OBJ_LAYER
		var/drop_rate		= 100
		Crossed(atom/movable/a)
			if(istype(a, /mob/player))
				var/mob/player/p = a
				if(p.health && (p in active_game.participants))
					effect(p)
		proc
			effect(mob/player/p)
				/*
					the effect that gets carried out on the player when crossing the item.
				*/
		health_pack
			icon_state	= "healthkit"
			drop_rate	= 100
			effect(mob/player/p)
				if(p.health < p.base_health)
					p.edit_health(round(p.base_health/5))
					GC()
		revive_pack
			icon_state	= "revive"
			drop_rate	= 70
			effect(mob/player/p)
				if(p.has_revive < 2)
					p.has_revive ++
					GC()
		shield_tier1
			icon_state	= "shield1"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(1, 0)
					GC()
		shield_tier2
			icon_state	= "shield2"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(2, 0)
					GC()
		shield_tier3
			icon_state	= "shield3"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(3, 0)
					GC()

		gun
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
				step		= 2
			pistol
				icon_state	= "pistol"
				state		= "pistol"
				gun_type	= /obj/weapon/gun/pistol
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Pistol", 1)
			kobra
				icon_state	= "kobra"
				state		= "kobra"
				gun_type	= /obj/weapon/gun/kobra
				step		= 4
				drop_rate	= 100
				effect(mob/player/p)
					p.float_text("\[E] - Kobra", 1)
			edge_lord
				icon_state	= "3dg3-10rd"
				state		= "3dg3-10rd"
				gun_type	= /obj/weapon/gun/edge_lord
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - 3DG3-10RD", 1)
			pink_dream
				icon_state	= "pinkdream"
				state		= "pinkdream"
				gun_type	= /obj/weapon/gun/pink_dream
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Pink Dream", 1)
			ak66
				icon_state	= "ak66"
				state		= "ak66"
				gun_type	= /obj/weapon/gun/ak66
				step		= 4
				drop_rate	= 50	// lower spawn chance since this gun is a hairy nutsack.
				effect(mob/player/p)
					p.float_text("\[E] - AK66", 1)
			krossbow
				icon_state	= "krossbow"
				state		= "krossbow"
				gun_type	= /obj/weapon/gun/krossbow
				step		= 4
				drop_rate	= 80
				effect(mob/player/p)
					p.float_text("\[E] - Krossbow", 1)
			uzi
				icon_state	= "uzi"
				state		= "uzi"
				gun_type	= /obj/weapon/gun/uzi
				step		= 4
				drop_rate	= 50
				effect(mob/player/p)
					p.float_text("\[E] - Uzi", 1)
			red_baron
				icon_state	= "redbaron"
				state		= "redbaron"
				gun_type	= /obj/weapon/gun/red_baron
				step		= 4
				drop_rate	= 25
				effect(mob/player/p)
					p.float_text("\[E] - Red Baron", 1)
			shotgun
				icon_state	= "shotgun"
				state		= "shotgun"
				gun_type	= /obj/weapon/gun/shotgun
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Shotgun", 1)
			hellsredeemer
				icon_state	= "hellredeemer"
				state		= "hellredeemer"
				gun_type	= /obj/weapon/gun/hellsredeemer
				step		= 4
				drop_rate	= 25
				effect(mob/player/p)
					p.float_text("\[E] - Hell's Redeemer", 1)
			flamethrower
				icon_state	= "flamethrower"
				state		= "flamethrower"
				gun_type	= /obj/weapon/gun/flamethrower
				step		= 4
				drop_rate	= 25
				effect(mob/player/p)
					p.float_text("\[E] - Flamethrower", 1)
			spas_12
				icon_state	= "spas12"
				state		= "spas12"
				gun_type	= /obj/weapon/gun/spas_12
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - SPAS-12", 1)

		melee
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
				step		= 2

		special
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
			grenade
				icon_state	= "grenade"
				state		= "grenade"
				gun_type	= /obj/weapon/special/grenade
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Grenades", 1)
			molotov
				icon_state	= "molotov"
				state		= "molotov"
				gun_type	= /obj/weapon/special/molotov
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Molotovs", 1)
			airstrike
				icon_state	= "airstrike"
				state		= "airstrike"
				gun_type	= /obj/weapon/special/airstrike
				drop_rate	= 30
				effect(mob/player/p)
					p.float_text("\[E] - Airstrikes", 1)
			fireball
				icon_state	= "fireball"
				state		= "fireball"
				gun_type	= /obj/weapon/special/fireball
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Fireball", 1)
			glowsticks
				icon_state	= "glowsticks"
				state		= "glowsticks"
				gun_type	= /obj/weapon/special/glowsticks
				drop_rate	= 80
				effect(mob/player/p)
					p.float_text("\[E] - Glowsticks", 1)
			cowbell
				icon_state	= "cowbell"
				state		= "cowbell"
				gun_type	= /obj/weapon/special/cowbell
				drop_rate	= 75
				effect(mob/player/p)
					p.float_text("\[E] - Cowbell", 1)