


mob
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
			for(var/mob/npc/support/s in support_ai)
				if(s.alive) spec_list += s
			if(spec_list.len) 	{client.eye 	= pick(spec_list);src << "spectating: [client.eye]"}
			else				{client.eye 	= src;src << "nobody to spectate; watching self."}


		spectate_new()
			var/list/spec_list = new/list()
			for(var/mob/player/p in active_game.participants)
				if(p == src || !p.health || p.died_already) continue
				else spec_list += p
			for(var/mob/npc/support/s in support_ai)
				if(s.alive) spec_list += s
			if(spec_list.len > 1)	// if there's others to watch...
				client.eye = pick(spec_list-client.eye) //... pick one that isn't the one already watched.
				src << "spectating: [client.eye]"
			else if(!spec_list.len)	// if there is nobody to watch, reset the eye.
				client.eye = src
				src << "nobody to spectate; spectating self."

mob/player
	verb
		specNew()
			set hidden = 1
			if(died_already || src in active_game.spectators)
				spectate_new()