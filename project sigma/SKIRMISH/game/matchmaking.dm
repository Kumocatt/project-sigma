
#define RAIN 1
#define SNOW 2
#define BLOODRAIN 3

var
	game/active_game 	= new /game	// the datum of the current active game.

mob/player
	verb
		vote_to_skip()
			set hidden = 1
			if(winget(src, "pane-lobby.to-skip", "is-checked") == "true")
				active_game.votes_to_skip --
			else
				active_game.votes_to_skip ++


game
	var
		started			= 0	/*
								0 - game has not been initiated and is currently sleeping while waiting for players.
								1 - game is initialized and preparing; connecting players should still be dumped in the lobby but
										should also see a timer and any pre-game lobby stuff.
								2 - game is prepared and active; connecting players should be dropped into the game.
							*/
		current_round	= 1		// the current round.
		last_match_round= 1		// the last wave reached on the last match.
		last_map		= "Limbo"// the name of the last map played.
		exp_multiplier	= 1		// multiply exp gain by this.
		enemies_left	= 1		// how many enemies are currently alive.
		enemies_total	= 1		// how many enemies to be spawned total.
		map_spawnlimit	= 30
		toggle_regen	= 1		// use to toggle health regeneration on/off.
		toggle_revive	= 1		// use to toggle revives on/off.
		votes_to_skip	= 0
		needed_skips	= 0
		intermission	= 0		// 1 if it's an intermission between waves.
		gameover		= 1

		/*
			vv Unique wave flags. vv
		*/
		phantom_enemies		= 0		// use to toggle alpha'd enemies.
		crawler_only		= 0		// use to make only crawlers spawn.
		abstract_only		= 0		// use to make only abstracts spawn.
		beholder_only		= 0		// use to make only beholders spawn.
		blaze_only			= 0		// use to make only blazes spawn.

		censorship			= 0		// use to give all mobs censor bars.
		explosive_enemies	= 0		// use to make all enemies explode on death.
		blackout			= 0		// use to take all player spotlights away.
		dis_regenerate		= 0		// use to disable health regeneration.
		laser_madness		= 0		// use to make all projectiles lasers.
		nyan_madness		= 0		// use to make all projectiles nyan cats.
		fire_madness		= 0		// use to make all projectiles fire bullets.
		twisted_terror		= 0		// use to make screen rotate slowly
		boss_mode			= 0
		deathmatch			= 0
		toggle_weather		= 1		// 1 if its weathering
		weather_type		= BLOODRAIN	// what kind of weather; RAIN, SNOW, BLOODRAIN

		list/participants	= new/list()		// a list of every player that is playing.
		list/spectators		= new/list()		// a list of every player that is spectating.
		list/player_spawns	= new/list()		// a list of all the locs players can spawn on.
		list/enemy_spawns	= new/list()
		list/hazard_spawns	= new/list()		// a list of locs that map hazards can spawn on(i.e. lava).
		list/portals		= new/list()		// a list of all the portals on the map.
		list/weather_turfs	= new/list()
		map/next_map	// this is the map that's currently being chosen to be played.
		mob/top_player


	proc

		wait_loop()
			set waitfor = 0
			if(started) return
			for()
				if(length(participants))
					break
				sleep 10
			init_game()



		init_game()
			started = 1
			if(!participants.len && !spectators.len) world.Reboot()
			next_map = pick(available_maps)
			needed_skips	= 1
			if(participants.len > 2) needed_skips = round(participants.len/2)
			update_grid() ////
			for(var/mob/player/p in (participants+spectators))
				winset(p,,"child1.left=\"pane-lobby\"")
				winset(p,,"pane-lobby.next-map.text=\"[next_map.name]\"")
				winset(p,,"pane-lobby.map-info.text=\"[next_map.desc]\"")
				winset(p, "pane-lobby.to-skip", "text=0/[needed_skips]")
				winset(p, "pane-lobby.skip-button", "is-checked=\"false\"")
				winset(p, "pane-lobby.specbutton", "is-disabled=\"false\"")
				if(p in participants) winset(p, "pane-lobby.specbutton", "is-checked=\"false\"")
				else winset(p, "pane-lobby.specbutton", "is-checked=\"true\"")
				participants << output("<b>++ [p] joined the lobby.</b>","lobbychat")
				spectators << output("<b>++ [p] joined the lobby.</b>","lobbychat")

			for(var/i = 15, i, i--)
				if(votes_to_skip >= needed_skips)
					next_map 		= pick(available_maps-next_map)
					votes_to_skip 	= 0

				for(var/mob/player/p in (participants+spectators))
					if(i == 29) winset(p, "pane-lobby.specbutton", "is-disabled=\"false\"")
					if("[winget(p, "pane-lobby.next-map", "text")]" != "[next_map.name]")
						winset(p,,"pane-lobby.next-map.text=\"[next_map.name]\"")
						winset(p,,"pane-lobby.map-info.text=\"[next_map.desc]\"")
						winset(p, "pane-lobby.skip-button", "is-checked=\"false\"")
					winset(p, "pane-lobby.to-skip", "text=[votes_to_skip]/[needed_skips]")
					winset(p, "pane-lobby.game-countdown", "text=\"Game in [i]..\"")
					if(i == 5) winset(p, "pane-lobby.specbutton", "is-disabled=\"true\"")
					sleep world.tick_lag
				sleep 10
				if(i == 1 && !participants.len)
					world << "waiting for participants.."
					i = 30
			active_game.last_map = next_map.name
			var/dmm_suite/new_reader = new()
			new_reader.load_map(next_map.dmm_file, 2)
			for(var/mob/player/p in participants)
				winset(p,,"child1.left=\"pane-map\"")
				p.health		= p.base_health
				p.kills			= 0
				p.alpha			= 0
				p.pixel_y		= 64
				p.loc			= pick(player_spawns)
				animate(p, pixel_y = 0, alpha = 255, easing = QUAD_EASING, time = 20)
				p.move_disabled	= 0
				p.can_hit		= 1
				p.shield(1, 0)

			for(var/mob/player/p in spectators)
				winset(p,,"child1.left=\"pane-map\"")
				p.spectate_rand()
			gameover= 0
			started = 2
			weather_loop()
			init_wave()


		init_wave()
			if(!participants.len && !spectators.len) world.Reboot()
			world << "<b>Wave [current_round] will begin in 15 seconds."
			sleep 150
			intermission = 0
			weather_type = pick(RAIN, SNOW, BLOODRAIN)
					// first let's check for boss mode triggers.
			if(current_round == 4)
				boss_mode = 1
				boss_doppleganger()
			else if(current_round >= 5 && participants.len > 1 && prob(8))
				boss_mode = 1
				boss_deathmatch()
									// if no boss mode was triggered, let's look at some wave modifiers.
			if(!boss_mode && prob(55))
				if(prob(15))	// phantom enemies only.
					phantom_enemies = 1
				if(prob(10))	// make players and feeders naked with a censor bar. **HUMOR**
					censorship		= 1
				if(prob(15))	// the following will decide if the wave will only spawn a certain type of enemy.
					switch(rand(1,4))
						if(1) crawler_only	= 1
						if(2) beholder_only	= 1
						if(3) abstract_only	= 1
						if(4) blaze_only	= 1
				if(prob(10) && !abstract_only) // make every enemy explode upon death.
					explosive_enemies 	= 1
				if(prob(5))		// the following will determine if the wave will have any projectile modifiers.
					switch(rand(1,3))
						if(1) laser_madness	= 1
						if(2) nyan_madness	= 1
						if(3) fire_madness	= 1

			if(!boss_mode)
				enemies_total	= (beholder_only||blaze_only?round(1.5*current_round):round(10*current_round+3*participants.len))
				enemies_left	= enemies_total
				world << SOUND_WAVE_BEGIN
				for(var/mob/player/p in active_game.participants)
					p.waveStart.alpha = 0
					p.waveStart.transform = turn(p.transform,180)
					p.client.screen += p.waveStart
					animate(p.waveStart, alpha = 255, transform = matrix(), time = 10, easing = BOUNCE_EASING, loop = 1)
					spawn(20)
						animate(p.waveStart, alpha = 0, time = 5, loop = 1)
						sleep 5
						p.client.screen -= p.waveStart
				sleep world.tick_lag
				world << pick( MUSIC_FAST_ACE, MUSIC_RETRO140, MUSIC_ROCKER, MUSIC_HORROR1, MUSIC_DnB1, MUSIC_SPOOBOOKY)
				sleep world.tick_lag

				if(censorship) for(var/mob/player/p in participants)
					p.censor()

				for(var/i = 1 to enemies_total)								// enemy spawning.
					while(ai_list.len >= map_spawnlimit) sleep 5
					if(started == 1) break
					var/mob/npc/hostile/h 	= garbage.Grab(/mob/npc/hostile/feeder)
					h.icon_state 			= pick("grey","pink","white","purple","green","orange","blue")
				//	if(prob(5)) h = garbage.Grab(/mob/npc/hostile/petite_feeder)
					if(current_round >= 3 && prob(10))
						h = garbage.Grab(pick(/mob/npc/hostile/brute, /mob/npc/hostile/puker))
					if(current_round >= 5 && prob(15)) //5, 15
						h = garbage.Grab(pick(/mob/npc/hostile/hellbat, /mob/npc/hostile/abstract, /mob/npc/hostile/abstract2, /mob/npc/hostile/beholder, \
												/mob/npc/hostile/shade, /mob/npc/hostile/blaze))
					if(current_round >= 10 && prob(10))
						h = garbage.Grab(/mob/npc/hostile/slammer)
					if(current_round >= 2 && prob(10))
						h = garbage.Grab(/mob/npc/hostile/charger)

					if(crawler_only || current_round >= 2 && prob(35))
						h = garbage.Grab(/mob/npc/hostile/crawler)
						h.icon_state = pick("grey","white")
					if(abstract_only)
						h = garbage.Grab(pick(/mob/npc/hostile/abstract, /mob/npc/hostile/abstract2))
					if(blaze_only)
						h = garbage.Grab(/mob/npc/hostile/blaze)

					spawn_en(h)

					if(h.can_phantom && (phantom_enemies || prob(10)))
						animate(h, alpha = 110, time = 20, loop = -1, easing = ELASTIC_EASING)
						animate(alpha = 90, time = 20, loop = -1, easing = ELASTIC_EASING)
					if(explosive_enemies || prob(10))
						h.is_explosive = 1
					if(istype(h, /mob/npc/hostile/feeder))
						if(prob(5)) h.shield(rand(1,3), 1)
					sleep world.tick_lag
				if(dis_regenerate)		dis_regenerate 		= 0
				if(crawler_only)		crawler_only		= 0
				if(beholder_only)		beholder_only		= 0
				if(abstract_only)		abstract_only		= 0
				if(blaze_only)			blaze_only			= 0
				if(phantom_enemies)		phantom_enemies		= 0




		progress_check()
			if(gameover || started != 2) return
			if(!participants.len)
				spawn end_game()
				return
			if(boss_mode || enemies_left)
				var/mob/player/p
				for(var/i = 1 to participants.len)
					p = participants[i]
					if(p.health) break
					if(!p.health && i == participants.len)
						gameover = 1
						world << SOUND_WAVE_LOSE			// all players dead
						world << sound(null, 0, 0, 3)
						spawn end_game()
						return
				if(enemies_left == 5)
					for(var/mob/player/m in participants)
						if(m.health)
							for(var/mob/npc/hostile/h in ai_list)
								m.add_target(h)
								h.targeted = 1
			else if(!intermission)
				intermission = 1
				sleep 20
				world << SOUND_WAVE_END
				current_round ++
				if(laser_madness)	laser_madness	= 0
				if(nyan_madness)	nyan_madness	= 0
				if(fire_madness)	fire_madness	= 0
				// revive dead players, etc.
				for(var/mob/player/p in participants)
					if(p.censored) p.censor(1)
					if(top_player && top_player != p)
						if(p.kills > top_player.kills)
							top_player.overlays.Remove(CROWN_OVERLAY)
							p.overlays.Add(CROWN_OVERLAY)
							top_player = p
						if(p.kills == top_player.kills)
							top_player.overlays.Remove(CROWN_OVERLAY)
							top_player = null
					else
						top_player = p
						p.overlays.Add(CROWN_OVERLAY)
					p.waveComplete.alpha = 0
					p.waveComplete.transform = turn(p.transform,180)
					p.client.screen += p.waveComplete
					animate(p.waveComplete, alpha = 255, transform = matrix(), time = 10, easing = BOUNCE_EASING, loop = 1)
					if(p.health)
						if(p.health < p.base_health/2)
							p.health = round(p.base_health/2)				/// players with less than half their hp get it restored to half.
					spawn(20)
						animate(p.waveComplete, alpha = 0, time = 5, loop = 1)
						sleep 5
						p.client.screen -= p.waveComplete
					if(!p.health)
						p.health		= p.base_health
						p.client.eye	= p
						p.density		= 1
						p.alpha			= 0
						p.pixel_y		= 32
						p.loc			= pick(player_spawns)
						animate(p, pixel_y = 0, alpha = 255, easing = QUAD_EASING, time = 15)
						p.move_disabled	= 0
						p.can_hit		= 1
						p.died_already	= 0
				init_wave()


		end_game()
			if(!participants.len && !spectators.len) world.Reboot()
			if(started == 1) return
			started 			= 1
			sleep 40
			last_match_round	= current_round
			current_round		= 1
			exp_multiplier		= 1
			enemies_left		= 1
			enemies_total		= 1
			toggle_regen		= 1
			toggle_revive		= 1
			laser_madness		= 0
			nyan_madness		= 0
			fire_madness		= 0
			crawler_only		= 0
			beholder_only		= 0
			abstract_only		= 0
			blaze_only			= 0
			boss_mode			= 0
			deathmatch			= 0


			player_spawns		= new/list()
			enemy_spawns		= new/list()
			ai_list				= new/list()
			active_projectiles	= new/list()
			portals				= new/list()
			weather_turfs		= new/list()
			for(var/mob/player/p in participants)
				winset(p, "pane-lobby.game-countdown", "text=\"Submitting Scores..\"")
				winset(p,,"child1.left=\"pane-lobby\"")
				p.loc 			= locate(1,1,1)
				p.client.eye	= p
				p.density		= 1
				p.can_hit		= 0
				p.died_already	= 0
				p.submit_scores()													//			UNCOMMENT THIS
			for(var/mob/player/p in spectators)
				p.client.eye	= p
				winset(p,,"child1.left=\"pane-lobby\"")
			for(var/area/a in world) del a
			for(var/turf/t in world)
				if(t.z == 1) continue
				if(t.contents) for(var/atom/movable/a in t)
					if(a.is_garbage)
						a.GC()
					else del a
				new /turf(t)
			world.maxx	= 14
			world.maxy	= 11
			//	sleep world.tick_lag
			init_game()


	// WAVE VARIANT PROCS --- the following procs run in the background of waves and manage the more complicated aspects of their event type.



		boss_deathmatch()
			/* last man standing!
			*/
			set waitfor = 0
			deathmatch = 1
			world << "Last Man Standing -- PvP Round!"
			world << SOUND_WAVE_BEGIN
			for(var/mob/player/p in active_game.participants)
				p.deathmatch.alpha = 0
				p.deathmatch.transform = turn(p.transform,180)
				p.client.screen += p.deathmatch
				animate(p.deathmatch, alpha = 255, transform = matrix(), time = 10, easing = BOUNCE_EASING, loop = 1)
				spawn(20)
					animate(p.deathmatch, alpha = 0, time = 5, loop = 1)
					sleep 5
					p.client.screen -= p.deathmatch
			sleep world.tick_lag
			world << MUSIC_ESCAPE_FROM_CITY
			var/timer = 0	// used to track the deathmatch duration to initiate sudden death when needed.
			while(started == 2)
				timer ++
				var/living_players = 0
				if(timer == 300) world << "Sudden Death!"
				for(var/mob/player/p in participants)
					if(p.health)
						living_players ++
					if(timer >= 300) // 300*20 = one minute roughly
						//sudden death time
						missile_strike(p.loc)
				if(living_players <= 1)
					if(living_players) for(var/mob/player/p in participants)
						if(p.health && !p.died_already)
							p << "you win!"
							p.shield(3)
							p.has_revive = 2
							break
					break
				sleep 20
			sleep 25 // this is here to give time for the last player that died to get processed.
			if(!intermission)
				intermission = 1
				world << SOUND_WAVE_END
				current_round ++
				sleep 5// revive dead players, etc.
				for(var/mob/player/p in participants)
					p.client.screen += p.waveComplete
					if(p.health)
						if(p.health < p.base_health/2)
							p.health = round(p.base_health/2)
					spawn(20)
						animate(p.waveComplete, alpha = 0, time = 5, loop = 1)
						sleep 5
						p.client.screen -= p.waveComplete
					if(!p.health)
						p.health		= p.base_health
						p.client.eye	= p
						p.density		= 1
						p.move_disabled	= 0
						p.can_hit		= 1
						p.alpha			= 255
						p.loc			= pick(player_spawns)
						p.died_already	= 0
				boss_mode 	= 0
				deathmatch	= 0
				init_wave()


		boss_doppleganger()
			set waitfor = 0
			world << MUSIC_BOSS_DOPPLE_THEME
			for(var/mob/player/p in active_game.participants)
				p.waveStart.alpha = 0
				p.waveStart.transform = turn(p.transform,180)
				p.client.screen += p.waveStart
				animate(p.waveStart, alpha = 255, transform = matrix(), time = 10, easing = BOUNCE_EASING, loop = 1)
				spawn(20)
					animate(p.waveStart, alpha = 0, time = 5, loop = 1)
					sleep 5
					p.client.screen -= p.waveStart
			sleep 10
			var/total = round((active_game.participants.len)/1.5)
			if(total <= 0) total = 1
			for(var/i = 0, i < total, i++)
				var/mob/npc/hostile/doppleganger/boss = new
				boss.draw_nametag("<font color=red>_-DOPPLE-_") //,, -44)
				boss.draw_health(-5, 32)
				boss.arms.icon_state = "base-pistol"
				boss.overlays += boss.arms
				boss.overlays += boss.shirt
				boss.overlays += boss.pants
				boss.overlays += boss.hair
				boss.step_size		= 4
				boss.health		= boss.base_health
				boss.loc		= pick(player_spawns)
				for(var/mob/player/p in participants)
					p.add_target(boss)
					boss.targeted = 1
				ai_list += boss
			world << SOUND_WAVE_BEGIN
			world << 'dopple.wav'
			sleep world.tick_lag*2
			while(started == 2)
				if(ai_list.len == 0)
					world << ">> <b>Boss Cleared!</b>"
					break
				sleep world.tick_lag*2
			if(!intermission && started == 2)
				intermission = 1
				sleep 35
				world << SOUND_WAVE_END
				current_round ++
				sleep 5// revive dead players, etc.
				for(var/mob/player/p in participants)
					p.client.screen += p.waveComplete
					if(p.health)
						if(p.health < p.base_health/2)
							p.health = round(p.base_health/2)
					spawn(20)
						animate(p.waveComplete, alpha = 0, time = 5, loop = 1)
						sleep 5
						p.client.screen -= p.waveComplete
					if(!p.health)
						p.health		= p.base_health
						p.client.eye	= p
						p.density		= 1
						p.move_disabled	= 0
						p.can_hit		= 1
						p.alpha			= 255
						p.loc			= pick(player_spawns)
						p.died_already	= 0
				sleep 15
				boss_mode 	= 0
				init_wave()