

var
	game/active_game 	= new /game	// the datum of the current active game.
	speed_fluxer		= 0

mob/player
	verb
		vote_to_skip()
			set hidden = 1
		//	if(winget(src, "pane-lobby.to-skip", "is-checked") == "true")
		//		active_game.votes_to_skip --
		//	else
		//		active_game.votes_to_skip ++


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
		censorship			= 0		// use to give all mobs censor bars.
		beholder_only		= 0		// use to make only beholders spawn.
		explosive_enemies	= 0		// use to make all enemies explode on death.
		blackout			= 0		// use to take all player spotlights away.
		dis_regenerate		= 0		// use to disable health regeneration.
		laser_madness		= 0		// use to make all projectiles lasers.
		nyan_madness		= 0		// use to make all projectiles nyan cats.
		invincible_one		= 0		// randomly selects and makes an enemy temporarily invincible.
		speed_flux			= 0		// use to make random groups of enemies move at random speeds.
		bloody_trigger		= 0		// use to make each hit on an enemy deal 2 damage to the player.
		twisted_terror		= 0		// use to make screen rotate slowly
		boss_mode			= 0
		deathmatch			= 0

		list/participants	= new/list()		// a list of every player that is playing.
		list/spectators		= new/list()		// a list of every player that is spectating.
		list/player_spawns	= new/list()		// a list of all the locs players can spawn on.
		list/enemy_spawns	= new/list()
		list/hazard_spawns	= new/list()		// a list of locs that map hazards can spawn on(i.e. lava).
		list/portals		= new/list()		// a list of all the portals on the map.
		map/next_map	// this is the map that's currently being chosen to be played.


	proc

		wait_loop()
			set waitfor = 0
			if(started) return
			for()
				if(length(participants))
					break
				sleep 10
			world << "initializing game.."
			init_game()



		init_game()
			started = 1
			if(!participants && !spectators) world.Reboot()
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
					if("[winget(p, "pane-lobby.next-map", "text")]" != "[next_map.name]")
						winset(p,,"pane-lobby.next-map.text=\"[next_map.name]\"")
						winset(p,,"pane-lobby.map-info.text=\"[next_map.desc]\"")
						winset(p, "pane-lobby.skip-button", "is-checked=\"false\"")
					winset(p, "pane-lobby.to-skip", "text=[votes_to_skip]/[needed_skips]")
					winset(p, "pane-lobby.game-countdown", "text=\"Game in [i]..\"")
					if(i == 5) winset(p, "pane-lobby.specbutton", "is-disabled=\"true\"")
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
	//			p.shield()

			for(var/mob/player/p in spectators)
				winset(p,,"child1.left=\"pane-map\"")
				p.spectate_rand()
			gameover= 0
			started = 2
			init_wave()


		init_wave()
			if(!participants && !spectators) world.Reboot()
			world << "<b>Wave [current_round] will begin in 15 seconds."
			sleep 150
			intermission = 0
			if(current_round == 8 && participants.len > 1)
				boss_mode = 1
				boss_deathmatch()
			if(current_round == 4)
				boss_mode = 1
				boss_doppleganger()
			if(!boss_mode && prob(1))	// stackable wave types
				if(prob(25))
					// only phantom enemies will spawn.
					phantom_enemies 	= 1
				if(prob(15))
					// only crawlers will spawn
					crawler_only		= 1
				if(prob(25))
					// censor bars will be drawn on all mobs. players are also naked.
					censorship			= 1
				if(!beholder_only && prob(10))
					// only beholders will spawn.
					beholder_only		= 1
	/*			if(prob(15))
					// explosive enemies.
					explosive_enemies 	= 1
				if(prob(15))
					// dis regenerate
					dis_regenerate		= 1
				if(prob(10))
					// laser madness
					laser_madness		= 1
				if(prob(10) && !laser_madness)
					// nyan madness
					nyan_madness		= 1
				if(prob(15))
					// invincible one
					invincible_one		= 1
					invincible_one()
				if(prob(15))
					// speed flux
					speed_flux			= 1
					speed_flux()
		//		if(prob(10))
					// bloody trigger
		//			bloody_trigger		= 1
*/
			if(!boss_mode)
				enemies_total	= (beholder_only?round(1.5*current_round):round(10*current_round+3*participants.len))
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
				world << pick( MUSIC_FAST_ACE, MUSIC_RETRO140, MUSIC_ROCKER, MUSIC_HORROR1, MUSIC_DnB1)
				sleep world.tick_lag

				if(censorship) for(var/mob/player/p in participants)
					p.censor()

				for(var/i = 1 to enemies_total)								// enemy spawning.
					while(ai_list.len >= map_spawnlimit) sleep 5
					if(started == 1) break
					var/mob/npc/hostile/h 	= garbage.Grab(/mob/npc/hostile/feeder)
					h.icon_state 			= pick("grey","pink","white","purple","green","orange")
					if(current_round >= 3 && prob(10))
						h = garbage.Grab(pick(/mob/npc/hostile/brute, /mob/npc/hostile/puker))
					if(current_round >= 5 && prob(15)) //5, 15
						h = garbage.Grab(pick(/mob/npc/hostile/hellbat, /mob/npc/hostile/abstract, /mob/npc/hostile/abstract2, /mob/npc/hostile/beholder))
					if(crawler_only || current_round >= 2 && prob(35))
						h = garbage.Grab(/mob/npc/hostile/crawler)
						h.icon_state = pick("grey","white")
					spawn_en(h)

					if(h.can_phantom && (phantom_enemies || prob(10)))
						animate(h, alpha = 110, time = 20, loop = -1, easing = ELASTIC_EASING)
						animate(alpha = 85, time = 20, loop = -1, easing = ELASTIC_EASING)
					if(explosive_enemies || prob(10))
						h.is_explosive = 1
					if(istype(h, /mob/npc/hostile/feeder))
						if(prob(5)) h.shield()
					sleep world.tick_lag
				if(phantom_enemies) 	phantom_enemies 	= 0
				if(crawler_only)		crawler_only		= 0
				if(censorship)			censorship			= 0
				if(beholder_only)		beholder_only		= 0
				if(explosive_enemies) 	explosive_enemies 	= 0
		//		if(blackout)			blackout			= 0




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
				// revive dead players, etc.
				for(var/mob/player/p in participants)
					if(p.censored) p.censor(1)
					if(dis_regenerate) dis_regenerate 	= 0
					if(laser_madness) laser_madness		= 0
					if(nyan_madness) nyan_madness		= 0
					if(invincible_one) invincible_one	= 0
					if(speed_flux)		speed_flux		= 0
					if(bloody_trigger) bloody_trigger	= 0
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
			//	boss_mode = 0
				init_wave()


		end_game()
			if(!participants && !spectators) world.Reboot()
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
			invincible_one		= 0
			speed_flux			= 0
			bloody_trigger		= 0
			boss_mode			= 0
			deathmatch			= 0


			player_spawns		= new/list()
			enemy_spawns		= new/list()
			ai_list				= new/list()
			active_projectiles	= new/list()
			portals				= new/list()
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


		invincible_one()
			/* every few seconds make a different mob invincible.
			*/
			set waitfor = 0
			var/mob/current_one	= new/list()
			while(invincible_one)
				if(ai_list.len > 1)
					var/mob/m = pick(ai_list)
					m.invincible()
					current_one = m
					sleep 50
					current_one.invincible(1)
					current_one = null
				sleep world.tick_lag*2

		speed_flux()
			/* every few seconds makes all enemies move at a different speed.
			*/
			set waitfor = 0
			while(speed_flux)
				speed_fluxer = pick(-1,0,2)
				sleep 50


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
			while(started == 2)
				var/living_players = 0
				for(var/mob/player/p in participants)
					if(p.health) living_players ++
				if(living_players <= 1)
					break
				sleep world.tick_lag*2
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
				var/mob/npc/hostile/doppleganger/boss1 = new
				boss1.draw_nametag("<font color=red>_-DOPPLE-_") //,, -44)
				boss1.draw_health(-5, 32)
				boss1.arms.icon_state = "base-pistol"
				boss1.overlays += boss1.arms
				boss1.overlays += boss1.shirt
				boss1.overlays += boss1.pants
				boss1.overlays += boss1.hair
				boss1.step_size		= 4
				boss1.health		= boss1.base_health
				boss1.loc			= pick(player_spawns)
				ai_list += boss1
			world << SOUND_WAVE_BEGIN
			sleep world.tick_lag*2
			while(started == 2)
				if(ai_list.len == 0)
					world << "Bosses killed!"
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