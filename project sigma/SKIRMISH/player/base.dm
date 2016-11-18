
mob/player
	appearance_flags	= KEEP_TOGETHER
	icon				= '_BaseT.dmi'
	icon_state			= "base-"
	density				= 1
	step_size			= 4
	bound_width			= 14
	var/tmp
	//	obj/head 		= new /obj/player/head
		obj/arms 		= new /obj/player/arms
		obj/shirt		= new /obj/player/shirt
		obj/pants		= new /obj/player/pants
		obj/hair 		= new /obj/player/hair
		pl_indicator	= new /obj/player/indicator


	proc
		draw_base()
			draw_planes()
			draw_nametag("[name]") //,, -44)
			refresh_hud()
			equipped_weapon 	= new /obj/weapon/gun/pistol
			equipped_special	= new /obj/weapon/special/grenade
			arms.icon_state		= "base-pistol"
			pants.icon_state	= "pants[pick(1,2)]"
			shirt.icon_state	= "shirt[rand(1,9)]"
			hair.icon_state		= "style[rand(1,13)]"
			if(key == "Amelia Pond")
				shirt.icon_state 	= "amelia-shirt"
				pants.icon_state 	= "amelia-pants"
				hair.icon_state		= "amelia1"
			if(key == "Ghost of ET")
				hair.icon_state		= "style8"
			if(key == "Kumorii")
				hair.icon_state		= "style13"
				shirt.icon_state	= "kumo-shirt"
				pants.icon_state	= "pants1"
			if(key == "Saskae7")
				shirt.icon_state	= "shirt9"
				pants.icon_state	= "pants2"
			if(hair.icon_state == "style11" || hair.icon_state == "style13") hair.pixel_x = -5
			overlays += arms
			overlays += shirt
			overlays += pants
			overlays += hair
			underlays += pl_indicator




		flick_arms(fstate = "base-")
		//	set waitfor = 0
			var/ogstate = arms.icon_state
			overlays -= arms
			arms.icon_state = "[fstate]"
			overlays += arms
			sleep 1
			overlays -= arms
			arms.icon_state = "[ogstate]"
			overlays += arms

		arms_state(nstate = "base-")
			overlays -= arms
			arms.icon_state	= "[nstate]"
			overlays += arms
obj/player

	arms
		icon		= '_Arms.dmi' //base-arms.dmi'
	//	icon_state	= "base-"
		layer		= FLOAT_LAYER+0.2

	shirt
		icon		= '_Clothes.dmi' //base-arms.dmi'
		icon_state	= "shirt1"
		layer		= FLOAT_LAYER+0.1
	pants
		icon		= '_Clothes.dmi' //base-arms.dmi'
		icon_state	= "pants"
		layer		= FLOAT_LAYER+0.1
	hair
		icon		= '_Hair.dmi' //base-arms.dmi'
		icon_state	= "style1"
		layer		= FLOAT_LAYER+0.2
		New()
			..()
			icon_state	= "style[rand(1,6)]"
	indicator
		icon				= 'game/misc_effects.dmi' //base-arms.dmi'
		icon_state			= "indicator"
		pixel_y				= -4
		pixel_x				= 1
		layer				= TURF_LAYER+0.3
		appearance_flags	= NO_CLIENT_COLOR | KEEP_APART