

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


	MUSIC_SPOOBOOKY				= sound('audio/music/spoobooky.ogg',1,0,volume = 70, channel = 3)
	MUSIC_ROCKER				= sound('audio/music/rocker.ogg',1,0,volume = 70, channel = 3)
	MUSIC_HORROR1				= sound('audio/music/horror1.ogg',1,0,volume = 70, channel = 3)
	MUSIC_FAST_ACE				= sound('audio/music/fastace.ogg',1,0,volume = 70, channel = 3)
	MUSIC_RETRO140				= sound('audio/music/retro140.ogg',1,0,volume = 70, channel = 3)
	MUSIC_DnB1					= sound('audio/music/DnB1.ogg',1,0,volume = 70, channel = 3)
	MUSIC_ESCAPE_FROM_CITY		= sound('audio/music/escape-from-the-city.ogg',1,0,volume = 30, channel = 3)
	MUSIC_BOSS_DOPPLE_THEME		= sound('audio/music/doppletheme.ogg',1,0,volume = 70, channel = 3)
	MUSIC_KNIVES				= sound('audio/music/knives.ogg',0,volume = 70, channel = 3)

