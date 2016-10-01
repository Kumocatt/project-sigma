


#define RENDER_WEATHER 1
var/tmp
	list/rainy_turfs	= list()	// this will be a list of all the turfs that have the rain animation set on them.
									// ** you COULD utilize this to "toggle the rain" with little effort.
proc
	rain_loop()
		set waitfor = 0
		if(!RENDER_WEATHER) return
		if(rainy_turfs.len)
			for()
				var/i 		= rand(1,rainy_turfs.len)	// to pick random tiles from the pool of rainy turfs.
				var/turf/t	= rainy_turfs[i]
				rainy_turfs -= t
				t.rain()
				rainy_turfs += t
				sleep world.tick_lag

turf
	proc
		rain()
			var/obj/weather/r = garbage.Grab(/obj/weather/rain)
			r.loc = src
			animate(r,icon_state = "rain[pick(1,3)]", pixel_y = 400, pixel_x = 0, alpha = 155, loop = 1)
			animate(pixel_y	= 5, pixel_x = pick(-10,10), time = 10.8)
			animate(icon_state = "rainland", time = rand(1.2, 4.8))
			spawn(17) r.GC()


obj/weather
	icon	= 'weather.dmi'
	layer	= EFFECTS_LAYER+11
	rain
		icon_state	= "rain1"
		is_garbage	= 1


/*
area
	rainy_area
		icon				= 'environment/x16.dmi'
		icon_state			= "rainmarker"		// the area will be deleted after runtime so the state is just to aid with mapping in the .dmm editor.
		layer				= EFFECTS_LAYER
		appearance_flags	= NO_CLIENT_COLOR
		var/tmp/rain_intensity = 10
	//	New()
	//		..()
	//		for(var/turf/t in contents)
	//			rainy_turfs += t
	//		del src
*/