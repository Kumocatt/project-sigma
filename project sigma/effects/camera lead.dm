


mob/player
//	Move()
//		..()
//		camera_pos()

	var/tmp
		camera_dir

	proc/getDirMove(dir)
		var/x = 10
		if(equipped_weapon) x = equipped_weapon.sight_range
		switch(dir)
			if(NORTH)
				return list(0,1,x)
			if(SOUTH)
				return list(0,-1,x)
			if(EAST)
				return list(1,0,x)
			if(WEST)
				return list(-1,0,x)
			if(NORTHEAST)
				return list(1,1,x)
			if(NORTHWEST)
				return list(-1,1,x)
			if(SOUTHEAST)
				return list(1,-1,x)
			if(SOUTHWEST)
				return list(-1,-1,x)

	proc/camera_pos(default = 0)
		/* if default = 1, wil return to center.
			*/
		if(client)
			if(default)
				if(client.pixel_x != 0 || client.pixel_y != 0)
					animate(client, pixel_x = 0, pixel_y = 0, time = 5)
					camera_dir = null

			else if(camera_dir != dir)
				camera_dir = dir
				var/X = getDirMove(dir)
				animate(client,pixel_x=X[1]*X[3],pixel_y=X[2]*X[3],time=5)
				return