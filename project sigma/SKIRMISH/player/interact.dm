

mob
	player
		verb
			interact()
				set hidden = 1
				/*
					press e to interact with nearby things in the world.
				*/
				if(died_already || src in active_game.spectators)
					specNew()
				for(var/atom/movable/a in obounds(src, 1))
					if((istype(a, /obj/item/gun) || istype(a, /obj/item/melee)) && a:gun_type != equipped_weapon.type)
				//		world << "[src] got the [a]."
						var/obj/item/DROP		= garbage.Grab(equipped_weapon.drop_type)
						DROP.loc				= loc
						DROP.step_x				= step_x
						DROP.step_y				= step_y
						equipped_weapon 		= new a:gun_type
						arms_state("base-[a:state]")
						step_size				= a:step
						a.GC()
						break

					if(istype(a, /obj/item/special) && a:gun_type != equipped_special.type)
				//		world << "[src] got the [a]."
						var/obj/item/special/DROP	= garbage.Grab(equipped_special.drop_type)
						DROP.loc					= loc
						DROP.step_x					= step_x
						DROP.step_y					= step_y
						equipped_special 			= new a:gun_type
						a.GC()
						break

				//	if(istype(a, /obj/barricade))
						// pull that bitch.