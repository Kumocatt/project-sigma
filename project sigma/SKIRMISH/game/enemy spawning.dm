

proc
	spawn_en(mob/npc/hostile/h)
		if(h)
			var/obj/_loc
			var/mob/player/p

			while(!_loc && active_game.started == 2)
				if(active_game.participants.len)
					p = pick(active_game.participants)
					if(p.loc)
						for(var/obj/markers/enemy_spawn/espawn in oview(15,p))
							if(get_dist(espawn, p) > 5 && (espawn in active_game.enemy_spawns))
								. = 1
								for(var/atom/movable/a in espawn.loc)		// prevent enemies from spawning on top of other enemies, players, and barricades
									if(a.density) . = 0;break
								if(.) _loc = espawn
				sleep 5
			if(_loc)
				active_game.enemy_spawns -= _loc
				h.loc 		= _loc.loc
				h.health	= h.base_health
				h.can_hit	= 1
				if(active_game.current_round >= 5) h.step_size = h.step_size+1		// late game enemies all move faster!
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
			if(_loc) loc = _loc.loc;can_hit = 1

//
	//	respawn()
	//		var/obj/_loc 		= pick(active_game.enemy_spawns)
	//		var/mob/player/p	= pick(active_game.participants)
	//		for(var/obj/markers/enemy_spawn/espawn in oview(p, 45))
	//			_loc = espawn
	//			break
	//		loc = _loc.loc