
mob
	var/tmp
		bloodyfeet	= 0	// 1 if the mob should leave a trail of bloody footprints.




atom/movable
	proc

		drop_boom()
			/*
				called to drop a charred object to simulate an explosion point.
			*/
			var/obj/gore/boom/b		= garbage.Grab(/obj/gore/boom)
			b.icon					= 'gore.dmi'
			b.icon_state			= "boom[pick(1,2)]"
			b.SetCenter(Cx(),Cy(),z)
			animate(b, pixel_y = -8, time = 3)
			b.spawndel(300)



		drop_blood(var/i = 1, splat = 0)
			/*
				called to drop blood from an arom.
				i = how many blood drops to.. well, drop.
			*/
			if(!splat)
				for(var/obj/gore/blood/bl in obounds(src,4))
					. ++
				if(. < 5) for(var/v = 0 to i)
					var/obj/gore/blood/b	= garbage.Grab(/obj/gore/blood)
					b.icon					= 'gore.dmi'
					b.icon_state			= "blood[rand(1,10)]"
					b.layer					= TURF_LAYER+0.15
					b.transform				= b.transform/4
					b.SetCenter(Cx(),Cy(),z)
					animate(b, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
					animate(pixel_y = rand(-8,8), time = 3)
					animate(transform = matrix(), time = 20)
					b.spawndel(300)
					sleep world.tick_lag*2
			else
				var/obj/gore/blood/b	= garbage.Grab(/obj/gore/blood)
				b.icon					= 'gore.dmi'
				b.icon_state			= "splat[rand(1,3)]"
				b.SetCenter(Cx(),Cy(),z)
				animate(b, pixel_y = -8, time = 3)
				b.spawndel(300)
				for(var/v = 0 to i)
					var/obj/gore/blood/g	= garbage.Grab(/obj/gore/blood)
					g.icon					= 'gore.dmi'
					g.icon_state			= "gut[rand(1,5)]"
					g.layer					= TURF_LAYER+0.16
					g.SetCenter(Cx(),Cy(),z)
					animate(g, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
					animate(pixel_y = rand(-8,8), time = 3)
					g.spawndel(300)
					sleep world.tick_lag*2

obj/gore
	icon		= 'gore.dmi'
	layer		= TURF_LAYER+0.15
	is_garbage	= 1

	blood
//		Crossed(atom/movable/m)
//			if(ismob(m))
//				var/mob/b = m
//				if(!b.bloodyfeet) b.bloodyfeet	= 1
	boom
		layer	= TURF_LAYER+0.17

