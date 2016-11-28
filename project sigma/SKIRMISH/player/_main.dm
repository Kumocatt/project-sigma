

client
	perspective		= (EYE_PERSPECTIVE | EDGE_PERSPECTIVE)
//	control_freak 	= (CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS)



mob
	player
		var
			tmp
				died_already= 0
				kills		= 0
	//	Stat()
	//		stat("Wave:",active_game.current_round)
	//		stat("Enemies:","[active_game.enemies_left]/[active_game.enemies_total]")

		Login()
			..()
			winset(src,null,"hwmode=true;")
			if(winget(src,null,"hwmode")=="false") del src
			src << MUSIC_KNIVES
			loc = locate(1,1,1)
			MovementLoop()
			draw_base()
			sleep 10
			active_game.participants += src
			src << output("<center>Welcome to mystery game! Keep in mind this is a work in progress so pardon the wet paint!","lobbychat")
			src << output("<center><b><u>Controls</u><br>W,A,S,D to move.<br>Arrow keys to shoot.<br>Shift to dash.<br>Space+Arrow keys to use specials.<br>E to pickup weapons/spectate new.</b>","lobbychat")
			if(active_game.started == 2) // if game is already going on..
				winset(src,,"child1.left=\"pane-map\"")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				health			= base_health
				move_disabled	= 0
				can_hit			= 1
				alpha			= 255
				loc 			= pick(active_game.player_spawns)
			if(active_game.started == 1)
				winset(src,,"child1.left=\"pane-lobby\"")
				winset(src,,"pane-lobby.next-map.text=\"[active_game.next_map.name]\"")
				winset(src, "pane-lobby.to-skip", "text=0/[active_game.participants.len>1?round(active_game.participants.len/2.5):1]")
				winset(src, "pane-lobby.skip-button", "is-checked=\"false\"")
				winset(src, "pane-lobby.specbutton", "is-checked=\"false\"")
				active_game.participants << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				active_game.spectators << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				active_game.update_grid()


		Logout()
			remove_spectators()
			..()
			world << "<b>-- <font color = [namecolor]>[src]</font> disconnected."
			active_game.participants << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
			active_game.spectators << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
			if(src in active_game.spectators)
				active_game.spectators -= src
			if(src in active_game.participants)
				active_game.participants -= src
				if(active_game.started == 2) spawn active_game.progress_check()
			active_game.update_grid()
			del src


		death()
			if(client.eye != src || died_already) return
			died_already 	= 1
			..()
			remove_spectators()
			if(censored)	censor(1)
			client.eye		= loc
			loc				= locate(1,1,1)
			move_disabled 	= 1
			alpha			= 0
			world << "<b><font color = [namecolor]>[src]</font> died! ([kills] kills)"
			active_game.participants << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.spectators << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.progress_check()
			spawn(10) if(active_game.started == 2)	// if the game is still active after the player dies..
				spectate_rand()
				auto_revive(active_game.current_round)	// if the game is still on after the player dies, auto revive them a minute after dying(if the game is still on)
