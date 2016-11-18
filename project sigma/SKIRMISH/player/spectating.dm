


mob/player
	proc
		remove_spectators()
			/* called to make all players that are spectating src spectate someone else -- if nobody is available returns their eye to their mob.
			*/
			for(var/mob/player/p in (active_game.participants+active_game.spectators))
				if(p == src) continue
				if(p.client.eye == src)	// if a client is watching src..
					p.spectate_rand()
		spectate_rand()
			/* called to make src spectate a random player -- if nobody is available returns their eye to their mob.
			*/
			var/list/spec_list = new/list()
			for(var/mob/player/p in active_game.participants)
				if(p == src) continue
				if(p.health && !p.died_already) spec_list += p
			if(spec_list.len) 	{client.eye 	= pick(spec_list);src << "spectating: [client.eye]"}
			else				{client.eye 	= src;src << "nobody to spectate; watching self."}
		spectate_new()
			var/list/spec_list = new/list()
			for(var/mob/player/p in active_game.participants)
				if(p == src) continue
				if(p.health && !p.died_already) spec_list += p
			if(spec_list.len > 1)
				client.eye 	= pick(spec_list)
				src << "spectating: [client.eye]"
			else
				client.eye 	= src
				src << "nobody to spectate; watching self."

	verb
		specNew()
			set hidden = 1
			if(!health || src in active_game.spectators)
				spectate_new()