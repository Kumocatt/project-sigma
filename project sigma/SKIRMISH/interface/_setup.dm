
#define DEBUG 1
//client/fps = 40
world
	name 			= "Feed -"
	view			= "13x10" //"25x20"  ||  13x10           208x160
	mob 			= /mob/player
	status			= "<b>Testing</b>"
	turf			= /turf/grass
	map_format		= TOPDOWN_MAP
	loop_checks 	= 0
	tick_lag		= 0.2
	icon_size		= 16
	fps				= 40
	hub				= "Kumorii.Feed"
	hub_password	= "mystery"

	New()
		..()
		log = file("feedlog.txt")
		setup_world()
		active_game.wait_loop()
proc
	setup_world()
		pre_recycle()
	//	daynight_tracker()
	//	rain_loop()
		ai_loop()
		projectile_loop()
