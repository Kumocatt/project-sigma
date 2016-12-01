

proc
	k_sound(atom/movable/a, sound/sfile)
	//	set waitfor = 0
		if(a && sfile)
			for(var/mob/player/p in active_game.participants)
				if(get_dist(a, p) <= 20)
					p << sfile


var
	current_song		= null	// The current song playing -- the song plays on repeat until the next game. A new song plays each wave.

	SOUND_GROWL1		= sound('audio/sounds/growl1.ogg', 0, volume = 20, channel = 0)
	SOUND_GROWL2		= sound('audio/sounds/growl2.ogg', 0, volume = 20, channel = 0)
	SOUND_CASING1		= sound('audio/sounds/dropped casing.wav', 0, volume = 20, channel = 0)
	SOUND_SHELL1		= sound('audio/sounds/shotty casing1.wav', 0, volume = 20, channel = 0)
	SOUND_RELOAD		= sound('audio/sounds/reload.wav', 0, volume = 70, channel = 0)
	SOUND_JUMP			= sound('audio/sounds/jump.wav', 0, volume = 70, channel = 0)

	SOUND_MOLOTOV1		= sound('audio/sounds/molotov1.wav', 0, volume = 20, channel = 0)
	SOUND_LASER1		= sound('audio/sounds/laser1.wav', 0, volume = 20, channel = 0)
	SOUND_COWBELL1		= sound('audio/sounds/cowbell.ogg', 0, volume = 70, channel = 0)

	SOUND_WAVE_BEGIN	= sound('audio/sounds/voice_wave_begin.ogg', 0, volume = 60, channel = 0)
	SOUND_WAVE_END		= sound('audio/sounds/voice_wave_complete.ogg', 0, volume = 60, channel = 0)
	SOUND_WAVE_LOSE		= sound('audio/sounds/voice_all_players_dead.ogg', 0, volume = 60, channel = 0)


	MUSIC_ROCKER				= sound('audio/music/rocker.ogg',1,0,volume = 70, channel = 3)
	MUSIC_HORROR1				= sound('audio/music/horror1.ogg',1,0,volume = 70, channel = 3)
	MUSIC_FAST_ACE				= sound('audio/music/fastace.ogg',1,0,volume = 70, channel = 3)
	MUSIC_RETRO140				= sound('audio/music/retro140.ogg',1,0,volume = 70, channel = 3)
	MUSIC_DnB1					= sound('audio/music/DnB1.ogg',1,0,volume = 70, channel = 3)
	MUSIC_ESCAPE_FROM_CITY		= sound('audio/music/escape-from-the-city.ogg',1,0,volume = 30, channel = 3)
	MUSIC_BOSS_DOPPLE_THEME		= sound('audio/music/doppletheme.ogg',1,0,volume = 70, channel = 3)
	MUSIC_KNIVES				= sound('audio/music/knives.ogg',0,volume = 70, channel = 3)


/*
		// <--------- Atmospheric --------->

	SOUND_WIND 				= sound('audio/sound/wind[edit].ogg',1, volume = 60, channel = 50)

		// <--------- Weapons --------->

	SOUND_GRENADE 				= sound('audio/sound/grenade.ogg',0, volume = 60, channel = 10)
	SOUND_GUNFIRE1 			= sound('audio/sound/gun1.ogg',0, volume = 60, channel = 12)
	SOUND_GUNFIRE2 			= sound('audio/sound/gun2.ogg',0, volume = 60, channel = 12)
	SOUND_SHOTGUN 				= sound('audio/sound/shotgun1.ogg',0, volume = 90, channel = 13)
	SOUND_CROSSBOW 			= sound('audio/sound/crossbow1.ogg',0, volume = 90, channel = 14)

		// <--------- Enemy sounds --------->

	SOUND_ZGROWL1 				= sound('audio/sound/growl1.ogg',0, volume = 60)
	SOUND_ZGROWL2 				= sound('audio/sound/growl2.ogg',0, volume = 60)

		// <--------- Interface --------->

	SOUND_CLICK				= sound('audio/sound/click.ogg',0, volume = 100)

		// <--------- Announcement --------->

	SOUND_WAVE_BEGINING 		= sound('audio/sound/voice_wave_begin.ogg',0, volume = 60)
	SOUND_WAVE_COMPLETE 		= sound('audio/sound/voice_wave_complete.ogg',0, volume = 62)
	SOUND_ACHIEVEMENT_U 		= sound('audio/sound/voice_au.ogg',0, volume = 60)
	SOUND_ALL_PLAYERS_DEAD 		= sound('audio/sound/voice_all_players_dead.ogg',0, volume = 60)

		// <--------- Music --------->

	MUSIC_WAIT 				= sound('audio/music/wait.ogg',1,volume = 30, channel = 3)


	MUSIC_SIMPLY_NO_CHANCE 		= sound('audio/music/simply_no_chance[loop].ogg',1,volume = 30, channel = 3)
	MUSIC_NO_WHERE_TO_RUN 		= sound('audio/music/no_where_to_run[loop].ogg',1,volume = 30, channel = 3)
	MUSIC_FIVE 				= sound('audio/music/five.ogg',1,volume = 30, channel = 3)
	MUSIC_TWO 				= sound('audio/music/two.ogg',1,volume = 30, channel = 3)
	MUSIC_THREE 				= sound('audio/music/three.ogg',1,volume = 30, channel = 3)

				// <--- Lists --->

	list {

		s_gun			= list (SOUND_GUNFIRE1, SOUND_GUNFIRE2) // <--- The list that the gun "pop" is chosen from.
		s_growl			= list (SOUND_ZGROWL1, SOUND_ZGROWL2) // <--- The list that the zombie's "growl" is chosen from.

		MUSIC_SOUNDTRACK 	= list (MUSIC_SIMPLY_NO_CHANCE, MUSIC_NO_WHERE_TO_RUN, MUSIC_FIVE, MUSIC_TWO, MUSIC_THREE)
	}
}

		// <--------- Proc(s) --------->

proc
	Cycle_Music() // <--- Proc that decides what mucis track will be played for the duration of the match.
		CURRENT_MUSIC = pick(MUSIC_SOUNDTRACK)

		*/