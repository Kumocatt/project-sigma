
proc
	get_drop()
		var/obj/drop_this = /obj/item/health_pack	// defaults to health packs because they're the most practical.
		if(prob(55))
			drop_this	= pick(0,0)
		if(prob(44))
			drop_this	= pick(0,0)
		if(prob(22))
			drop_this 	= pick(0,0)
		return drop_this

obj
	item
		icon				= 'items.dmi'
		is_garbage			= 1
		appearance_flags	= NO_CLIENT_COLOR
		layer				= OBJ_LAYER
		var/drop_rate
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
			drop_rate	= 50
			effect(mob/player/p)
				if(!p.has_revive)
					p.has_revive = 1
					GC()
		shield
			icon_state	= "shield1"
			drop_rate	= 50
			effect(mob/player/p)
				if(!p.has_shield)
					p.shield()
					GC()
		strong_shield
			icon_state	= "shield2"
			drop_rate	= 50
			effect(mob/player/p)
				if(!p.has_shield)
					p.blueshield()
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
				effect(mob/player/p)
					p.float_text("\[E] - Pistol", 1)
			kobra
				icon_state	= "kobra"
				state		= "kobra"
				gun_type	= /obj/weapon/gun/kobra
				step		= 4
				effect(mob/player/p)
					p.float_text("\[E] - Kobra", 1)
			edge_lord
				icon_state	= "3dg3-10rd"
				state		= "3dg3-10rd"
				gun_type	= /obj/weapon/gun/edge_lord
				step		= 4
				effect(mob/player/p)
					p.float_text("\[E] - 3DG3-10RD", 1)
			pink_dream
				icon_state	= "pinkdream"
				state		= "pinkdream"
				gun_type	= /obj/weapon/gun/pink_dream
				step		= 4
				effect(mob/player/p)
					p.float_text("\[E] - Pink Dream", 1)
			ak66
				icon_state	= "ak66"
				state		= "ak66"
				gun_type	= /obj/weapon/gun/ak66
				step		= 3
				effect(mob/player/p)
					p.float_text("\[E] - AK66", 1)
			krossbow
				icon_state	= "krossbow"
				state		= "krossbow"
				gun_type	= /obj/weapon/gun/krossbow
				step		= 3
				effect(mob/player/p)
					p.float_text("\[E] - Krossbow", 1)
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
				effect(mob/player/p)
					p.float_text("\[E] - Grenades", 1)
			molotov
				icon_state	= "molotov"
				state		= "molotov"
				gun_type	= /obj/weapon/special/molotov
				effect(mob/player/p)
					p.float_text("\[E] - Molotovs", 1)
