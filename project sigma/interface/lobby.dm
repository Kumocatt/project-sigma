


mob/player
	var/tmp
		spectoggle_off 	= 0
		spec_cooldown	= 0
	verb
		lobby_chat(t as text)
			set hidden = 1
			active_game.participants << output("<b><font color = [namecolor]>[src]</font>:</b> [html_encode(t)]", "lobbychat")
			active_game.spectators << output("<b><font color = [namecolor]>[src]</font>:</b> [html_encode(t)]", "lobbychat")
			world << "<b><font color = [namecolor]>[src]</font>:</b> [html_encode(t)]"
			if(active_game.started == 2)
				winset(src, "pane-map.map1", "focus=\"true\"")

		toggle_spectate()
			set hidden = 1
			if(winget(src, "pane-lobby.specbutton", "is-checked") == "true")
				if(spectoggle_off)
					winset(src, "pane-lobby.specbutton", "is-checked=\"false\"")
					return
				active_game.participants << output("<b><font color = [namecolor]>[src]</font></b> opted to spectate.", "lobbychat")
				active_game.spectators << output("<b><font color = [namecolor]>[src]</font></b> opted to spectate.", "lobbychat")
				active_game.participants.Remove(src)
				active_game.spectators.Add(src)
			else
				if(spectoggle_off)
					winset(src, "pane-lobby.specbutton", "is-checked=\"true\"")
					return
				active_game.participants << output("<b><font color = [namecolor]>[src]</font></b> opted to participate.", "lobbychat")
				active_game.spectators << output("<b><font color = [namecolor]>[src]</font></b> opted to participate.", "lobbychat")
				active_game.participants.Add(src)
				active_game.spectators.Remove(src)
			spectoggle_off = 1
			active_game.update_grid()
			sleep 5
			spectoggle_off = 0

		focus_chat()
			set hidden = 1
			winset(src, "debugoutput.input2", "focus=\"true\"")


game
	proc
		update_grid()
			for(var/mob/player/p in (participants+spectators))
				winset(p,"lobbygrid",{"cells="1x[participants.len+spectators.len+1]""})
				p << output("<center><u><b>Players</b>","lobbygrid:1,1")
				var/i = 1
				for(var/mob/player/m in participants)							//	Searches through the contents list
					p << output("<center><font color = [m.namecolor]>[m] -- participating","lobbygrid:1,[++i]")
				for(var/mob/player/m in spectators)							//	Searches through the contents list
					p << output("<center><font color = [m.namecolor]>[m] -- spectating","lobbygrid:1,[++i]")