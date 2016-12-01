mob/proc/playSound(soundfile,vol=100)
	if(client)
		src << sound(soundfile,volume=vol*sfx_volume)

atom/proc/viewSound(soundfile,viewrange=8,_volume=100,_frequency=0)
	var/sound/S = sound(soundfile)
	S.frequency = _frequency
	for(var/mob/M in hearers(viewrange,src))
		if(M.client)
			S.volume=_volume*M.sfx_volume
			M << S

#define AMBIANCE 16
atom
	proc/gs(f)
		viewSound(f,20,50,rand(5,15)*0.1)
mob
	var
		music_volume=100
		sfx_volume = 100

	var/tmp/ambiance = null
	var/tmp/repeated_ambiance = null


	verb/toggleMusic()
		if(music_on)
			music_on=0
		else
			music_on=1
		playMusic(ambiance,1,1)


	proc/playAmbiance(am,do_repeat=1,let_over=0,_volume=60)

		if(am != ambiance || let_over)
			ambiance = am

			if(music_on)
				src << sound(am,repeat=do_repeat,channel=16,volume=_volume*music_volume)
			else
				src << sound(null,repeat=do_repeat,channel=16)

	proc/ambiance()
		playAmbiance(over_music)
	proc/ps(f)
		playSound(f)

mob
	var/tmp/over_music
	var/music_on=1
	proc/playMusic(f,do_repeat=1,let_over=0)
		over_music = f

		src:playAmbiance(over_music,do_repeat,let_over)
		return

	proc/playMusic2(f,do_repeat=1,let_over=0)
		over_music = f

		src:playAmbiance(over_music,do_repeat,let_over,_volume=100*music_volume)
		return

	proc/playMusic3(f,do_repeat=1,let_over=0)
		over_music = f

		src:playAmbiance(over_music,do_repeat,let_over,_volume=25*music_volume)
		return