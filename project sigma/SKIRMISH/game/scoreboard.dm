

mob
	player
	//	var/tmp
	//		survived_wave	= 0
		proc
			submit_scores()

				var/scoreboard_kills	= world.GetScores(name, "Wave")
				if(scoreboard_kills)
					var
						list/params		= params2list(scoreboard_kills)
					if(params["Wave"])
						scoreboard_kills	= text2num(params["Wave"])
						if(active_game.last_match_round > scoreboard_kills)
							var/export_this = list("Kills" = kills, "Wave" = active_game.last_match_round, "Map" = active_game.last_map, "ID" = client.computer_id)
							world.SetScores(name, list2params(export_this))
				else
					var/export_this	= list("Kills" = kills, "Wave" = active_game.last_match_round, "Map" = active_game.last_map, "ID" = client.computer_id)
					world.SetScores(name, list2params(export_this))




/*

		verb
			delete_scoreboard()
				var/IDs	= world.GetScores(50, "Wave")
				if(IDs)
					world << "debug: got IDs"
					var/list/params = params2list(IDs)
					world<<"<b>IDs</b>"
					for(var/i=1, i<params.len, ++i)
						var/ID = params[i]
						world<<"[i]. [ID]"
						world.SetScores(ID, "")
				world << "Done"

				*/