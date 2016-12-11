

#define RENDER_WEATHER 0

proc
	weather_loop()
		set waitfor = 0
		if(!RENDER_WEATHER) return
		if(active_game.weather_turfs.len && active_game.started == 2)
			while(active_game.started == 2)
				if(active_game.toggle_weather)
					var/turf/t = pick(active_game.weather_turfs)
					active_game.weather_turfs -= src
					switch(active_game.weather_type)
						if(1)	t.rain()
						if(2)	t.snow()
						if(3)	t.bloodrain()
					sleep world.tick_lag
				else sleep 10

turf
	proc
		rain()
			set waitfor = 0
			var/obj/weather/r = garbage.Grab(/obj/weather/rain)
			r.loc = src
			animate(r,icon_state = "rain[pick(1,3)]", transform = transform*2, pixel_y = 400, pixel_x = 8, alpha = 0, loop = 1)
			animate(transform = matrix(), pixel_y = 5, pixel_x = -8, alpha = 210, time = 10.8)
			animate(icon_state = "rainland", time = rand(1.2, 4.8))
			spawn(17) if(active_game.started == 2)
				active_game.weather_turfs += src
				r.GC()
		snow()
			set waitfor = 0
			var/obj/weather/r = garbage.Grab(/obj/weather/snow)
			r.loc = src
			animate(r,icon_state = "snow[pick(1,3)]", transform = transform*6, pixel_y = 400, pixel_x = 8, alpha = 0, loop = 1)
			animate(transform = transform/4, pixel_y = 300, pixel_x = -8, alpha = 210, time = 30.4)
			animate(transform = matrix(), pixel_y = 150, pixel_x = 8, alpha = 210, time = 30.4)
			animate(pixel_y	= 0, pixel_x = -8, alpha = 210, time = 26.4)
			animate(icon_state = "snowland", alpha = 0, time = 20)
			spawn(110) if(active_game.started == 2)
				active_game.weather_turfs += src
				r.GC()
		bloodrain()
			set waitfor = 0
			var/obj/weather/r = garbage.Grab(/obj/weather/bloodrain)
			r.loc = src
			animate(r,icon_state = "bloodrain[pick(1,3)]", transform = transform*2, pixel_y = 400, pixel_x = 8, alpha = 0, loop = 1)
			animate(transform = matrix(), pixel_y = 5, pixel_x = -8, alpha = 210, time = 10.8)
			animate(icon_state = "bloodrainland", time = rand(1.2, 4.8))
			spawn(17) if(active_game.started == 2)
				active_game.weather_turfs += src
				r.GC()

obj/weather
	icon	= 'weather.dmi'
	layer	= EFFECTS_LAYER+11
	rain
		icon_state	= "rain1"
		is_garbage	= 1
		plane		= 2
	snow
		icon_state	= "snow1"
		is_garbage	= 1
		plane		= 2
	bloodrain
		icon_state	= "bloodrain1"
		is_garbage	= 1
		plane		= 2
