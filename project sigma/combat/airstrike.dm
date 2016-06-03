

proc
	airstrike(turf/_loc, mob/_caller)
		/*
			airstrikes send a small barrage of missiles down on/around a given location.
		*/
		if(_loc && active_game.started == 2)
			var/list/t_list = new /list()
			for(var/turf/t in view(1,_loc))
				if(!t.density) t_list += t
			if(t_list.len)
				for(var/turf/t in t_list)
					var/obj/projectile/p 	= garbage.Grab(/obj/projectile/airstrike)
					p.dir					= SOUTH
					p.max_step				= 20
					p.accuracy				= pick(4,7)
					p.sway					= pick(2, -2)
					p.alpha					= 150
					p.transform				= p.transform*2
					p.owner					= _caller
					var/turf/targ 			= locate(t.x, t.y+8, t.z)
					p.loc					= targ
					active_projectiles += p
					sleep pick(2,5)