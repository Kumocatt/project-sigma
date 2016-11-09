


mob/player
	var/tmp
		init_shake	= 0

	proc
		screenshake()
		//	set waitfor = 0
			if(!init_shake)
				init_shake = 1
				animate(client, pixel_x = 10, pixel_y = 10, time = 2, loop = 1)
				animate( pixel_x = -10, pixel_y = -10, time = 2)
				animate( pixel_x = 10, time = 2)
				animate( pixel_x = -10, pixel_y = 10, time = 2)
				animate( pixel_x = 0, pixel_y = 0, time = 2)
				sleep 10
				init_shake = 0