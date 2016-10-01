
obj/markers
	player_spawn
		icon		= 'environment/x16.dmi'
		icon_state	= "pspawn"
		New()
			..()
			active_game.player_spawns += loc
			del src
	enemy_spawn
		icon		= 'environment/x16.dmi'
		icon_state	= "espawn"
		New()
			..()
			active_game.enemy_spawns += src
			icon_state = null
	hazard_spawn
		icon		= 'environment/x16.dmi'
		icon_state	= "hspawn"
		New()
			..()
			active_game.hazard_spawns += loc
			del src
	dense
		icon 		= 'environment/x16.dmi'
		icon_state	= "dense"
		New()
			..()
			var/turf/t 	= loc
			t.density	= 1
			del src


obj
	overlays
		tree1
			icon		= '96x96.dmi'
			icon_state	= "tree t1"
			layer		= MOB_LAYER+10
			New()
				..(); if(prob(15)) icon_state = "tree t[pick(1,2)]"
		hedge_tl
			icon		= '_new x16.dmi'
			icon_state	= "hedge tl"
			layer		= MOB_LAYER
			pixel_y		= 16
		hedge_t
			icon		= '_new x16.dmi'
			icon_state	= "hedge t"
			layer		= MOB_LAYER
			pixel_y		= 16
		hedge_tr
			icon		= '_new x16.dmi'
			icon_state	= "hedge tr"
			layer		= MOB_LAYER
			pixel_y		= 16
		chainlink
			icon		= '_new x32.dmi'
			icon_state	= "chainlink1-t"
			layer		= MOB_LAYER+2
		chainlinkL
			icon		= '_new x32.dmi'
			icon_state	= "chainlink2-t"
			layer		= MOB_LAYER+2
		chainlinkR
			icon		= '_new x32.dmi'
			icon_state	= "chainlink3-t"
			layer		= MOB_LAYER+2




		obelisk
			icon		= '96x96.dmi'
			icon_state	= "obelisk t"
			layer		= MOB_LAYER+10
		gothic_fence
			icon		= 'new32x32.dmi'
			icon_state	= "gothic fence"
			layer		= MOB_LAYER+10
			pixel_y		= 16
		column
			icon		= 'new64x64.dmi'
			icon_state	= "column t"
			layer		= MOB_LAYER+10
		mausoleum
			icon		= 'mausoleum.dmi'
			icon_state	= "top"
			layer		= MOB_LAYER+5


turf
	icon = '_new x16.dmi'
	grass
		icon_state = "grass1"
		New()
			..(); if(prob(45)) icon_state = "grass[rand(1,6)]"
	road
		icon_state	= "road1"
		New()
			..()
			if(prob(5)) icon_state = "road[rand(1,4)]"
	dirt
		icon_state	= "dirt1"
		New()
			..()
			if(prob(25)) icon_state = "dirt[rand(1,4)]"
	buildings
		icon_state		= "b1A"
		density			= 1
		layer			= TURF_LAYER+0.2
		b2A/icon_state	= "b2A"
		b3A/icon_state	= "b3A"
		b4A/icon_state	= "b4A-1"//; New() { ..(); icon_state = "b4A-[pick(1,2)]" }
		b5A/icon_state	= "b5A-1"//; New() { ..(); icon_state = "b5A-[pick(1,2)]" }
		b6A/icon_state	= "b6A-1"//; New() { ..(); icon_state = "b6A-[pick(1,2)]" }
		b1B/icon_state	= "b1B"
		b2B/icon_state	= "b2B"
		b3B/icon_state	= "b3B"
		b4B/icon_state	= "b4B-1"//; New() { ..(); icon_state = "b4B-[pick(1,2)]" }
		b5B/icon_state	= "b5B-1"//; New() { ..(); icon_state = "b5B-[pick(1,2)]" }
		b6B/icon_state	= "b6B-1"//; New() { ..(); icon_state = "b6B-[pick(1,2)]" }
		roof
			icon_state		= "roof1"
			r2/icon_state	= "roof2"
			r3/icon_state	= "roof3"
			r4/icon_state	= "roof4"
			r5/icon_state	= "roof5"
			r6/icon_state	= "roof6"
			r7/icon_state	= "roof7"
			r8/icon_state	= "roof8"
			r9/icon_state	= "roof9"
			r10/icon_state	= "roof10"
			r11/icon_state	= "roof11"
			r12/icon_state	= "roof12"
			r13/icon_state	= "roof13"

	terrain
		parent_type		= /obj
		/* pretty much any non-ground set piece goes under here.
		*/
		details
			// just various small setpieces to help pull the maps together aesthetically.
			grass_sprouts
				icon		= '_new x16.dmi'
				icon_state	= "sprouts1"
				layer		= TURF_LAYER+0.2
				New()
					..()
					icon_state	= "sprouts[rand(1,4)]"
		hedge
			icon		= '_new x16.dmi'
			icon_state	= "hedge b"
			density		= 1
			layer		= TURF_LAYER+0.2
			d_ignore	= 1
			New()
				..()
				overlays += new /obj/overlays/hedge_t
		hedge_l
			icon		= '_new x16.dmi'
			icon_state	= "hedge bl"
			density		= 1
			layer		= TURF_LAYER+0.2
			d_ignore	= 1
			New()
				..()
				overlays += new /obj/overlays/hedge_tl
		hedge_r
			icon		= '_new x16.dmi'
			icon_state	= "hedge br"
			density		= 1
			layer		= TURF_LAYER+0.2
			d_ignore	= 1
			New()
				..()
				overlays += new /obj/overlays/hedge_tr
		sidewalk
			icon			= '_new x32.dmi'
			icon_state		= "sidewalk1"
			layer			= TURF_LAYER+0.1
			s2/icon_state	= "sidewalk2"
			s3/icon_state	= "sidewalk3"
			s4/icon_state	= "sidewalk4"
			s5/icon_state	= "sidewalk5"
			s6/icon_state	= "sidewalk6"
			s7/icon_state	= "sidewalk7"
			s8/icon_state	= "sidewalk8"
			s9/icon_state	= "sidewalk9"
		chainlink
			icon			= '_new x32.dmi'
			icon_state		= "chainlink1-b"
			density			= 1
			layer			= TURF_LAYER+2
			d_ignore		= 1
			New()
				..()
				overlays += new /obj/overlays/chainlink
			cl_left
				icon_state	= "chainlink2-b"
				bound_width	= 4
				bound_x		= 12
				New()
				//	..()
					overlays += new /obj/overlays/chainlinkL
			cl_right
				icon_state	= "chainlink3-b"
				bound_width	= 4
				New()
				//	..()
					overlays += new /obj/overlays/chainlinkR
		crosswalk
			icon			= '_new x32.dmi'
			icon_state		= "crosswalk1"
			layer			= TURF_LAYER+0.1
			c2/icon_state	= "crosswalk2"
		grass_edges
			icon			= '_new x16.dmi'
			layer			= TURF_LAYER+0.01
			e1/icon_state	= "grassedge1"
			e2/icon_state	= "grassedge2"
			e3/icon_state	= "grassedge3"
			e4/icon_state	= "grassedge4"
			e5/icon_state	= "grassedge5"
			e6/icon_state	= "grassedge6"
			e7/icon_state	= "grassedge7"
			e8/icon_state	= "grassedge8"
		roadline
			icon			= '_new x16.dmi'
			icon_state		= "roadline1"
			layer			= TURF_LAYER+0.1
			rl2/icon_state	= "roadline2"

		tree
			icon		= '96x96.dmi'
			icon_state	= "tree b"
			layer		= TURF_LAYER+0.2
			New()
				..()
				overlays += new /obj/overlays/tree1
		sewer
			icon			= 'new32x32.dmi'
			icon_state		= "sewer1"
			layer			= TURF_LAYER+0.1

		dumpster
			icon			= '64x64.dmi'
			icon_state		= "dumpster"
		helipad
			icon			= '96x96.dmi'
			icon_state		= "helipad"
			layer			= TURF_LAYER+0.1
		billboard
			icon			= '96x96.dmi'
			icon_state		= "billboard"
			layer			= TURF_LAYER+0.1
		pentagram
			icon			= '96x96.dmi'
			icon_state		= "pentagram"
			layer			= TURF_LAYER+0.1
			appearance_flags= NO_CLIENT_COLOR
		trashbag
			icon			= '32x32.dmi'
			icon_state		= "trashbag1"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
		obelisk
			icon			= '96x96.dmi'
			icon_state		= "obelisk b"
			layer			= TURF_LAYER+0.2
			New()
				..()
				overlays += new /obj/overlays/obelisk
		pond
			icon			= '_new x16.dmi'
			icon_state		= "pond7"
			density			= 1
			p2/icon_state	= "pond1"
			p3/icon_state	= "pond2"
			p4/icon_state	= "pond3"
			p5/icon_state	= "pond4"
			p6/icon_state	= "pond5"
			p7/icon_state	= "pond6"
			p8/icon_state	= "pond8"
			p9/icon_state	= "pond9"
			p10/icon_state	= "pond10"
			p11/icon_state	= "pond11"
			p12/icon_state	= "pond12"
			p13/icon_state	= "pond13"
		crashed_car
			icon			= '64x64.dmi'
			icon_state		= "car2"
			density			= 1
			bound_width		= 64
			bound_height	= 32
		car
			icon			= '64x64.dmi'
			icon_state		= "car1"
			density			= 1
			bound_width		= 64
			bound_height	= 32
		mausoleum
			icon			= 'mausoleum.dmi'
			layer			= TURF_LAYER+0.2
			New()
				..()
				overlays += new /obj/overlays/mausoleum
/*


		tree
			icon		= '96x96.dmi'
			icon_state	= "tree b"
			layer		= TURF_LAYER+0.2
			New()
				..()
				overlays += new /obj/overlays/tree

		factory
			icon			= '16x16.dmi'
			wall
				icon_state	= "factorywall1"
				density		= 1
				w2/icon_state	= "factorywall2"
				w3/icon_state	= "factorywall3"
				w4/icon_state	= "factorywall4"
				w5/icon_state	= "factorywall5"
				w6/icon_state	= "factorywall6"
				w7/icon_state	= "factorywall7"
				w8/icon_state	= "factorywall8"
				w9/icon_state	= "factorywall9"
				w10/icon_state	= "factorywall10"
				w11/icon_state	= "factorywall11"
				w12/icon_state	= "factorywall12"
				w13/icon_state	= "factorywall13"
				w14/icon_state	= "factorywall14"
				w15/icon_state	= "factorywall15"
				w16/icon_state	= "factorywall16"
				w17/icon_state	= "factorywall17"
				w18/icon_state	= "factorywall18"
				w19/icon_state	= "factorywall19"
				w20/icon_state	= "factorywall20"
				w21/icon_state	= "factorywall21"
				w22/icon_state	= "factorywall22"
				w23/icon_state	= "factorywall23"
				w24/icon_state	= "factorywall24"
				w25/icon_state	= "factorywall25"
				w26/icon_state	= "factorywall26"
				w27/icon_state	= "factorywall27"
				w28/icon_state	= "factorywall28"
				w29/icon_state	= "factorywall29"
				w30/icon_state	= "factorywall30"
				w31/icon_state	= "factorywall31"
				w32/icon_state	= "factorywall32"
				w33/icon_state	= "factorywall33"
				w34/icon_state	= "factorywall34"
				w35/icon_state	= "factorywall35"
				w36/icon_state	= "factorywall36"
				w37/icon_state	= "factorywall37"
				w38/icon_state	= "factorywall38"
				w39/icon_state	= "factorywall39"
				w40/icon_state	= "factorywall40"
			floor
				icon_state		= "factoryfloor1"
				f2/icon_state	= "factoryfloor2"
				f3/icon_state	= "factoryfloor3"
				f4/icon_state	= "factoryfloor4"
			acid
				icon_state		= "acid1"
				density			= 1
				a2/icon_state	= "acid2"
				a3/icon_state	= "acid3"
				a4/icon_state	= "acid4"
				a5/icon_state	= "acid5"
				a6/icon_state	= "acid6"
				a7/icon_state	= "acid7"
				a8/icon_state	= "acid8"
			bridge
				icon_state	= "bridge1"
				density		= 1
				b2/icon_state	= "bridge2"
				b3/icon_state	= "bridge3"
				b4/icon_state	= "bridge4"
				b5/icon_state	= "bridge5"
				b6/icon_state	= "bridge6"
				b7/icon_state	= "bridge7"
				b8/icon_state	= "bridge8"
				b9/icon_state	= "bridge9"
				b10/icon_state	= "bridge10"
				b11/icon_state	= "bridge11"
				b12/icon_state	= "bridge12"
				b13/icon_state	= "bridge13"
				b14/icon_state	= "bridge14"
				b15/icon_state	= "bridge15"
				b16/icon_state	= "bridge16"
				b17/icon_state	= "bridge17"
				b18/icon_state	= "bridge18"
				b19/icon_state	= "bridge19"
				b20/icon_state	= "bridge20"
				b21/icon_state	= "bridge21"
				b22/icon_state	= "bridge22"
		grass_edges
			icon			= '16x16.dmi'
			layer			= TURF_LAYER+0.01
			e1/icon_state	= "grassedge1"
			e2/icon_state	= "grassedge2"
			e3/icon_state	= "grassedge3"
			e4/icon_state	= "grassedge4"
			e5/icon_state	= "grassedge5"
			e6/icon_state	= "grassedge6"
			e7/icon_state	= "grassedge7"
			e8/icon_state	= "grassedge8"
		sidewalk
			icon			= 'new32x32.dmi'
			icon_state		= "sidewalk1"
			layer			= TURF_LAYER+0.1
		sidewalk2
			icon			= 'new32x32.dmi'
			icon_state		= "sidewalk2"
			layer			= TURF_LAYER+0.1
		sidewalk3
			icon			= 'new32x32.dmi'
			icon_state		= "sidewalk3"
			layer			= TURF_LAYER+0.1
		stoplight
			icon			= 'new32x32.dmi'
			icon_state		= "stoplight"
			layer			= EFFECTS_LAYER+0.1
		pole
			icon			= 'new16x16.dmi'
			icon_state		= "pole1"
			layer			= TURF_LAYER+0.2
			density			= 1
			p2
				icon_state	= "pole2"
				layer		= EFFECTS_LAYER
				density		= 0
			p3
				icon_state	= "pole3"
				layer		= EFFECTS_LAYER
				density		= 0
			p4
				icon_state	= "pole4"
				layer		= EFFECTS_LAYER
				density		= 0
			p5
				icon_state	= "pole5"
				layer		= EFFECTS_LAYER
				density		= 0
		payphone
			icon			= 'new32x32.dmi'
			icon_state		= "payphone"
			layer			= TURF_LAYER+0.1
		newspaper
			icon			= '32x32.dmi'
			icon_state		= "newspaper"
			layer			= TURF_LAYER+0.1
		box
			icon			= '32x32.dmi'
			icon_state		= "cardboard box"
			layer			= TURF_LAYER+0.1
		loading_door
			icon			= 'new64x64.dmi'
			icon_state		= "loading door"
			layer			= TURF_LAYER+0.3
		door
			icon			= 'new64x64.dmi'
			icon_state		= "door1"
			layer			= TURF_LAYER+0.3
		bottle
			icon			= 'game/items.dmi'
			icon_state		= "bottle1"
			layer			= TURF_LAYER+0.2
			New()
				..()
				icon_state	= "bottle[pick(1,2)]"
		window
			icon			= 'new64x64.dmi'
			icon_state		= "window1"
			layer			= TURF_LAYER+0.3
			New()
				..()
				icon_state	= "window[pick(1,2)]"
		guardrail
			icon			= 'new16x16.dmi'
			icon_state		= "top rail"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
			r2/icon_state	= "top rail2"
			r3/icon_state	= "top rail3"
			r4/icon_state	= "bottom rail"
			r5/icon_state	= "bottom rail2"
			r6/icon_state	= "bottom rail3"
		roadline
			icon			= '16x16.dmi'
			icon_state		= "roadline1"
			layer			= TURF_LAYER+0.1
			New()
				..()
				icon_state	= "roadline[pick(1,2)]"
		roadlineB
			icon			= '16x16.dmi'
			icon_state		= "roadlineB1"
			layer			= TURF_LAYER+0.1
			New()
				..()
				icon_state	= "roadlineB[pick(1,2)]"

		chainlink
			icon			= '32x32.dmi'
			icon_state		= "chainlink1"
			bound_width		= 32
			density			= 1
			layer			= TURF_LAYER+2
			d_ignore		= 1
			New()
				..()
				overlays += new /obj/overlays/chainlink
		drain
			icon			= 'new32x32.dmi'
			icon_state		= "drain1"
			layer			= TURF_LAYER+0.1
		sewer
			icon			= 'new32x32.dmi'
			icon_state		= "sewer1"
			layer			= TURF_LAYER+0.1

		dumpster
			icon			= '64x64.dmi'
			icon_state		= "dumpster"
		helipad
			icon			= '96x96.dmi'
			icon_state		= "helipad"
			layer			= TURF_LAYER+0.1
		billboard
			icon			= '96x96.dmi'
			icon_state		= "billboard"
			layer			= TURF_LAYER+0.1
		pentagram
			icon			= '96x96.dmi'
			icon_state		= "pentagram"
			layer			= TURF_LAYER+0.1
			appearance_flags= NO_CLIENT_COLOR
		trashbag
			icon			= '32x32.dmi'
			icon_state		= "trashbag1"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
		gothic2
			icon			= 'new16x16.dmi'
			icon_state		= "gothic2"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
		chainlink3
			icon			= 'new16x16.dmi'
			icon_state		= "chainlink3"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
		cart
			icon			= '32x32.dmi'
			icon_state		= "cart1"
			density			= 1
			d_ignore		= 1
			New()
				..()
				icon_state	= "cart[pick(1,2)]"
		obelisk
			icon			= '96x96.dmi'
			icon_state		= "obelisk b"
			layer			= TURF_LAYER+0.2
			New()
				..()
				overlays += new /obj/overlays/obelisk
		tombstone
			icon			= 'new32x32.dmi'
			icon_state		= "tombstone1"
			density			= 1
			d_ignore		= 1
			layer			= TURF_LAYER+0.2
			New()
				..()
				icon_state	= "tombstone[rand(1,3)]"
		gothic_fence
			icon			= 'new16x16.dmi'
			icon_state		= "gothic"
			layer			= TURF_LAYER+2
			density			= 1
			New()
				..()
				overlays += new /obj/overlays/gothic_fence
		gothic_gate
			icon			= 'new64x64.dmi'
			icon_state		= "gothic gate"
			density			= 1
		column
			icon			= 'new64x64.dmi'
			icon_state		= "column b"
			layer			= TURF_LAYER+2
			density			= 1
			New()
				..()
				overlays += new /obj/overlays/column
		car
			icon			= '64x64.dmi'
			icon_state		= "car1"
			density			= 1
			layer			= TURF_LAYER+0.3
		car2
			icon			= '64x64.dmi'
			icon_state		= "car2"
			density			= 1
			layer			= TURF_LAYER+0.3
		poster
			icon			= '32x32.dmi'
			icon_state		= "poster1"
			layer			= OBJ_LAYER+0.2
			New()
				..()
				icon_state	= "poster[rand(1,6)]"
		mausoleum
			icon			= 'mausoleum.dmi'
			New()
				..()
				overlays += new /obj/overlays/mausoleum

		wall1
			icon			= 'new32x32.dmi'
			icon_state		= "wall1"
			density			= 1
			New()
				..()
				icon_state	= "wall[rand(1,5)]"
		tile_wall
			icon			= 'new32x32.dmi'
			icon_state		= "tile wall"
			density			= 1
		traffic_guard
			icon			= '32x32.dmi'
			icon_state		= "trafficguard1"
			bound_width		= 32
			density			= 1
			layer			= TURF_LAYER+2
			d_ignore		= 1
			tg2
				icon_state	= "trafficguard2"
				bound_width	= 16
				bound_height= 32
		pond
			icon			= 'environment/x16.dmi'
			icon_state		= "pond1"
			density			= 1
			d_ignore		= 1
			p2/icon_state	= "pond2"
			p3/icon_state	= "pond3"
			p4/icon_state	= "pond4"
			p5/icon_state	= "pond5"
			p6/icon_state	= "pond6"
			p7/icon_state	= "pond7"
			p8/icon_state	= "pond8"
			p9/icon_state	= "pond9"
			p10/icon_state	= "pond10"
			p11/icon_state	= "pond11"
			p12/icon_state	= "pond12"
			p13/icon_state	= "pond13"
		blood
			icon		= 'gore.dmi'
			icon_state	= "blood1"
			layer		= TURF_LAYER+0.2
			New()
				..()
				icon_state	= "blood[rand(1,8)]"

*/
		effects
			icon		= 'x16.dmi'
			New()
				..()
				init_effect()

			proc/init_effect()
				/*
					If the effect has an animation or loop tied to it, define it in this proc. NOT under New().
				*/

			firefly
				icon				= 'environment/x16.dmi'
				icon_state			= "firefly1"
				plane				= 2
				appearance_flags	= NO_CLIENT_COLOR

				init_effect()
					set waitfor = 0
					animate( src, pixel_y = 32, time = 42, loop = -1)
					animate( pixel_x = 32, time = 42)
					animate( pixel_y = 0, time = 42)
					animate( pixel_x = 0, time = 42)


			cloud
				icon	= 'environment/cloud.dmi'
				layer	= EFFECTS_LAYER+9
				init_effect()
					set waitfor = 0
					animate( src, pixel_x = -200, alpha = 0, time = 250, loop = -1)
					animate( pixel_x = 200)
					animate( pixel_x = 0, alpha = 255, time = 250)