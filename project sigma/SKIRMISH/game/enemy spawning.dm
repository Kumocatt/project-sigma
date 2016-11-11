

proc
	spawn_en(mob/npc/hostile/h)
		if(h)
			var/obj/_loc
			var/mob/player/p

			while(!_loc && active_game.started == 2)
				p = pick(active_game.participants)
				if(p.loc)
					for(var/obj/markers/enemy_spawn/espawn in oview(20,p))
						if(get_dist(espawn, p) > 15 && (espawn in active_game.enemy_spawns))
							_loc = espawn
				sleep
			if(_loc)
				active_game.enemy_spawns -= _loc
				h.loc 		= _loc.loc
				h.health	= h.base_health
				ai_list += h
				sleep 5
				active_game.enemy_spawns += _loc


mob/npc
	proc
		respawn()
			var/obj/_loc
			var/mob/player/p

			while(!_loc && active_game.started == 2)
				p = pick(active_game.participants)
				if(p.loc)
					for(var/obj/markers/enemy_spawn/espawn in oview(20,p))
						if(get_dist(espawn, p) > 15 && (espawn in active_game.enemy_spawns))
							_loc = espawn
				sleep
			if(_loc) loc = _loc.loc

//
	//	respawn()
	//		var/obj/_loc 		= pick(active_game.enemy_spawns)
	//		var/mob/player/p	= pick(active_game.participants)
	//		for(var/obj/markers/enemy_spawn/espawn in oview(p, 45))
	//			_loc = espawn
	//			break
	//		loc = _loc.loc