

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



			delete_ID()

				var/IDs	= world.GetScores(50, "ID")
				if(IDs)
					world << "debug: got IDs"
					var/list/params = params2list(IDs)
					world<<"<b>IDs</b>"
					for(var/i=1, i<params.len, ++i)
						var/ID = params[i]
						world<<"[i]. [ID]"
						if(text2num(ID) == text2num(client.computer_id))
							world << "debug: matched!"
							var/scores 			= world.GetScores(i, "Name")
							var/list/params2 	= params2list(scores)
							world << "clearing [params2[1]].."
							world.SetScores(params2[params2.len])
							break