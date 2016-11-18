

mob/player
	var
		obj/weapon/equipped_weapon	= new /obj/weapon/gun/pistol
		obj/weapon/equipped_special	= new /obj/weapon/special/grenade
		trigger_dir	// tracks the direction that the player is shooting.
		trigger_down				= 0
		secondary_toggle			= 0
		reloading					= 0

	verb
		use_weapon(_dir as text)
			set hidden = 1
			if(health)
				if(_dir == "north") trigger_dir	= NORTH
				if(_dir == "south") trigger_dir	= SOUTH
				if(_dir == "east") trigger_dir	= EAST
				if(_dir == "west") trigger_dir	= WEST
				trigger_down ++
				if(!secondary_toggle && equipped_weapon && equipped_weapon.can_use && !reloading)
					equipped_weapon.use(src)
				if(secondary_toggle && equipped_special && equipped_special.can_use) equipped_special.use(src)
		use_weapon_up()
			set hidden = 1
			if(trigger_down) trigger_down --

		toggle_secondary_down()
			set hidden = 1
			usr:specNew()
			if(equipped_special && !secondary_toggle)
				secondary_toggle = 1
		toggle_secondary_up()
			set hidden = 1
			if(secondary_toggle)
				secondary_toggle = 0
		reload()
			set hidden = 1
			if(equipped_weapon && istype(equipped_weapon, /obj/weapon/gun) && equipped_weapon.can_use)
				var/obj/weapon/gun/weapon = equipped_weapon
				if(weapon.mag < weapon.mag_size) weapon.reload(src)
