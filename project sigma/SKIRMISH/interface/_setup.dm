
#define DEBUG 1
var/fonto = 'UberBit7.ttf'
world
	name 			= "Feed -"
	view			= "13x10" //"25x20"  ||  13x10           208x160
	mob 			= /mob/player
	status			= "<b>Open Testing</b>"
	turf			= /turf/grass
	map_format		= TOPDOWN_MAP
	loop_checks 	= 0
	tick_lag		= 2
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
		ai_loop()
		projectile_loop()
