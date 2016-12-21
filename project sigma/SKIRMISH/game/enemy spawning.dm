

proc
	spawn_en(mob/npc/hostile/h)
		if(h)
			var/obj/_loc
			var/mob/p

			while(!_loc && active_game.started == 2)
				if(active_game.participants.len)
					p = pick(active_game.participants+support_ai)
					if(p && p.loc)
						for(var/turf/espawn in oview(15,p)) //obj/markers/enemy_spawn/espawn in oview(15,p))
							if(get_dist(espawn, p) > 10 && (espawn in active_game.enemy_spawns))
								. = 1
								for(var/atom/movable/a in espawn)//.loc)		// prevent enemies from spawning on top of other enemies, players, and barricades
									if(a.density) . = 0;break
								if(.) _loc = espawn;break
				sleep 5
			if(_loc)
				active_game.enemy_spawns -= _loc
				h.loc 		= _loc//.loc
				h.health	= h.base_health
				h.can_hit	= 1
				if(active_game.current_round >= 5) h.step_size = h.step_size+1		// late game enemies all move faster!
				ai_list += h
				sleep 5
				active_game.enemy_spawns += _loc


mob/npc
	proc
		respawn()
			var/turf/_loc
			var/mob/player/p

			while(!_loc && active_game.started == 2)
				if(active_game.participants.len)
					p = pick(active_game.participants)
					if(p && p.loc)
						for(var/turf/espawn in oview(15, p))
							if(get_dist(espawn, p) > 10 && (espawn in active_game.enemy_spawns))
								. = 1
								for(var/atom/movable/a in espawn.loc)
									if(a.density) . = 0;break
								if(.) _loc = espawn;break
				sleep 5
			if(_loc)
				active_game.enemy_spawns -= _loc
				loc 	= _loc
				can_hit = 1
				sleep 5
				active_game.enemy_spawns += _loc
