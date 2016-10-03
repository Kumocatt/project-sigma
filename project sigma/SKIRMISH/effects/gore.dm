

atom/movable
	proc

		drop_boom()
			/*
				called to drop a charred object to simulate an explosion point.
			*/
			var/obj/gore/boom/b		= garbage.Grab(/obj/gore/boom)
			b.icon					= 'gore.dmi'
			b.icon_state			= "boom1"
			b.SetCenter(Cx(),Cy(),z)
			animate(b, pixel_y = -8, time = 3)
			b.spawndel(300)



		drop_blood(var/i = 1, splat = 0)
			/*
				called to drop blood from an arom.
				i = how many blood drops to.. well, drop.
			*/
			if(!splat)
				for(var/obj/gore/blood/bl in loc)
					. ++
				if(. < 4) for(var/v = 0 to i)
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
				b.icon_state			= "splat[pick(1,2)]"
				b.SetCenter(Cx(),Cy(),z)
				animate(b, pixel_y = -8, time = 3)
				b.spawndel(300)
				for(var/v = 0 to i)
					var/obj/gore/blood/g	= garbage.Grab(/obj/gore/blood)
					g.icon					= 'gore.dmi'
					g.icon_state			= "gut[rand(1,3)]"
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
	boom
		layer	= TURF_LAYER+0.17

