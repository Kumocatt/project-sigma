
proc
	get_drop()
		var/obj/drop_this = /obj/item/health_pack	// defaults to health packs because they're the most practical.
		if(prob(55))
			drop_this	= pick(/obj/item/special/shuriken, \
								/obj/item/special/mine, \
								/obj/item/gun/burst_rifle, \
								/obj/item/melee/club, \
								/obj/item/special/glowstick_g, \
								/obj/item/special/glowstick_b, \
								/obj/item/special/glowstick_r, \
								/obj/item/melee/sword, \
								/obj/item/special/cowbell)
		if(prob(44))
			drop_this	= pick(/obj/item/revive_pack, \
								/obj/item/gun/auto_rifle, \
								/obj/item/gun/crossbow, \
								/obj/item/gun/launcher, \
								/obj/item/special/molotov, \
								/obj/item/special/firewall, \
								/obj/item/gun/revolver, \
								/obj/item/gun/LB01, \
								/obj/item/gun/LB02, \
								/obj/item/shield, \
								/obj/item/gun/uzi, \
								/obj/item/gun/red_baron)
		if(prob(22))
			drop_this 	= pick(/obj/item/gun/force_palm, \
								/obj/item/special/fireball, \
								/obj/item/gun/flamethrower, \
								/obj/item/gun/sk47)
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
			icon_state	= "shield"
			drop_rate	= 50
			effect(mob/player/p)
				if(!p.has_shield)
					p.shield()
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
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Pistol", 1)
			burst_rifle
				icon_state	= "burstrifle"
				state		= "burstrifle"
				gun_type	= /obj/weapon/gun/burst_rifle
				drop_rate	= 45
				effect(mob/player/p)
					p.float_text("E- Burst Rifle", 1)
			auto_rifle
				icon_state	= "rifle"
				state		= "rifle"
				gun_type	= /obj/weapon/gun/auto_rifle
				drop_rate	= 50
				effect(mob/player/p)
					p.float_text("E- Assault Rifle", 1)
			crossbow
				icon_state	= "crossbow"
				state		= "crossbow"
				gun_type	= /obj/weapon/gun/crossbow
				drop_rate	= 35
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Crossbow", 1)
			launcher
				icon_state	= "launcher"
				state		= "launcher"
				gun_type	= /obj/weapon/gun/impact_launcher
				drop_rate	= 35
				step		= 2.8
				effect(mob/player/p)
					p.float_text("E- Launcher", 1)
			force_palm
				icon_state	= "forcepalm"
				state		= "fpalm"
				gun_type	= /obj/weapon/gun/force_palm
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Force Palm", 1)
			revolver
				icon_state	= "revolver"
				state		= "revolver"
				gun_type	= /obj/weapon/gun/revolver
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Revolver", 1)
			LB01
				icon_state	= "lb01"
				state		= "lb01"
				gun_type	= /obj/weapon/gun/LB01
				drop_rate	= 10
				step		= 2.8
				effect(mob/player/p)
					p.float_text("E- LB-01", 1)
			LB02
				icon_state	= "lb02"
				state		= "lb02"
				gun_type	= /obj/weapon/gun/LB02
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- LB-02", 1)
			shotgun
				icon_state	= "shotgun"
				state		= "shotgun"
				gun_type	= /obj/weapon/gun/shotgun
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Shotgun", 1)
			flamethrower
				icon_state	= "flamethrower"
				state		= "flamethrower"
				gun_type	= /obj/weapon/gun/flamethrower
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Flamethrower", 1)
			uzi
				icon_state	= "uzi"
				state		= "uzi"
				gun_type	= /obj/weapon/gun/uzi
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Uzi", 1)
			red_baron
				icon_state	= "redbaron"
				state		= "redbaron"
				gun_type	= /obj/weapon/gun/red_baron
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Red Baron", 1)
			sk47
				icon_state	= "sk47"
				state		= "sk47"
				gun_type	= /obj/weapon/gun/sk47
				drop_rate	= 10
				step		= 3
				effect(mob/player/p)
					p.float_text("E- SK47", 1)
		melee
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
				step		= 2
			club
				icon_state	= "club"
				state		= "club"
				gun_type	= /obj/weapon/club
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Club", 1)

			sword
				icon_state	= "sword"
				state		= "sword"
				gun_type	= /obj/weapon/sword
				step		= 3
				effect(mob/player/p)
					p.float_text("E- Sword", 1)


		special
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
			grenade
				icon_state	= "grenade"
				state		= "grenade"
				gun_type	= /obj/weapon/special/grenade
				effect(mob/player/p)
					p.float_text("E- Grenades", 1)
			shuriken
				icon_state	= "shuriken"
				state		= "shuriken"
				gun_type	= /obj/weapon/special/shuriken
				effect(mob/player/p)
					p.float_text("E- Shurikens", 1)
			mine
				icon_state	= "mine"
				state		= "mine"
				gun_type	= /obj/weapon/special/mine
				effect(mob/player/p)
					p.float_text("E- Mines", 1)
			molotov
				icon_state	= "molotov"
				state		= "molotov"
				gun_type	= /obj/weapon/special/molotov
				effect(mob/player/p)
					p.float_text("E- Molotovs", 1)
			fireball
				icon_state	= "fireball"
				state		= "fireball"
				gun_type	= /obj/weapon/special/fireball
				effect(mob/player/p)
					p.float_text("E- Fireballs", 1)
			firewall
				icon_state	= "firewall"
				state		= "firewall"
				gun_type	= /obj/weapon/special/firewall
				effect(mob/player/p)
					p.float_text("E- Firewall", 1)
			glowstick_g
				icon_state	= "glowstick-g"
				state		= "glowstick"
				gun_type	= /obj/weapon/special/glowstick_g
				effect(mob/player/p)
					p.float_text("E- Glowsticks", 1)
			glowstick_r
				icon_state	= "glowstick-r"
				state		= "glowstick"
				gun_type	= /obj/weapon/special/glowstick_r
				effect(mob/player/p)
					p.float_text("E- Glowsticks", 1)
			glowstick_b
				icon_state	= "glowstick-b"
				state		= "glowstick"
				gun_type	= /obj/weapon/special/glowstick_b
				effect(mob/player/p)
					p.float_text("E- Glowsticks", 1)
			cowbell
				icon_state	= "cowbell"
				state		= "cowbell"
				gun_type	= /obj/weapon/special/cowbell
				effect(mob/player/p)
					p.float_text("E- Cowbell", 1)
			airsupport
				icon_state	= "airsupport"
				state		= "airsupport"
				gun_type	= /obj/weapon/special/airsupport
				effect(mob/player/p)
					p.float_text("E- Air Support", 1)