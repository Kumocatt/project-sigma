



mob/player
	var
		namecolor = "#FFFFFF"
	verb
		submit_new_name(newname as text)
			set hidden = 1
			newname = html_encode(newname)
			if(length(newname) > 13)
				newname = copytext(newname, 1, 14)
			active_game.participants << output("<i>Notice: <font color = [namecolor]>[src]</font> has changed their name to <font color = [namecolor]>[newname]</font>.", "lobbychat")
			name = newname
			overlays -= nametag
			nametag.change_text("[src]")
			overlays += nametag
			active_game.update_grid()
			delete_ID()

		new_color(hex as color)
			set hidden = 1
			namecolor = hex
			overlays -= nametag
			nametag.change_color(hex)
			overlays += nametag
			active_game.update_grid()