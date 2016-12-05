client/verb
	toggle_fullscreen()
		if(!can_fs) return
		can_fs = 0
		if(!fs)
			fs=1
			winset(src,"default","titlebar=false")
			winset(src,"default","statusbar=false")
			winset(src,"default","can-resize=false")
			winset(src,"default","is-minimized=false")
			winset(src,"default","is-maximized=true")
			var/mob/player/p 			= mob
			p.waveComplete.screen_loc	= "SOUTH,WEST+2"
			p.waveStart.screen_loc		= "SOUTH,WEST+2"
			p.deathmatch.screen_loc		= "SOUTH,WEST+2"
		else
			fs=0
			winset(src,"default","titlebar=true")
			winset(src,"default","statusbar=false")
			winset(src,"default","can-resize=false")
			winset(src,"default","is-minimized=false")
			winset(src,"default","is-maximized=false")
			winset(src,"default","size=832x640")
			var/mob/player/p 			= mob
			p.waveComplete.screen_loc	= "SOUTH,WEST"
			p.waveStart.screen_loc		= "SOUTH,WEST"
			p.deathmatch.screen_loc		= "SOUTH,WEST"
		onResize()
		sleep 10
		can_fs = 1

client/var/fs=0
client/var/first=1
client/var/can_fs=1
