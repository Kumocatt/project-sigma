

#define RENDER_WEATHER 1

proc
	rain_loop()
		set waitfor = 0
		if(!RENDER_WEATHER) return
		if(active_game.rainy_turfs.len && active_game.started == 2)
			while(active_game.started == 2)
				if(active_game.toggle_rain)
					var/turf/t = pick(active_game.rainy_turfs)
					active_game.rainy_turfs -= src
					t.rain()
					sleep world.tick_lag
				else sleep 10

turf
	proc
		rain()
			set waitfor = 0
			var/obj/weather/r = garbage.Grab(/obj/weather/rain)
			r.loc = src
			animate(r,icon_state = "rain[pick(1,3)]", pixel_y = 400, pixel_x = 8, alpha = 0, loop = 1)
			animate(pixel_y	= 5, pixel_x = -8, alpha = 210, time = 10.8)
			animate(icon_state = "rainland", time = rand(1.2, 4.8))
			spawn(17) if(active_game.started == 2)
				active_game.rainy_turfs += src
				r.GC()


obj/weather
	icon	= 'weather.dmi'
	layer	= EFFECTS_LAYER+11
	rain
		icon_state	= "rain1"
		is_garbage	= 1
		plane		= 2


