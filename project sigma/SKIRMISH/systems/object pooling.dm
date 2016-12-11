

atom/movable
	var
		is_garbage = 0	// whether or not the obj should be recycled.
	proc
		GC()
			/*
				called to collect an object to the recycle pool.
			*/
	//		world << "Pooling [src]"
			alpha	= 255
			loc 	= null
			garbage.Add(src)

var
	objectPool/main_type/garbage = new/objectPool/main_type
	const
		ORECYCLE = 100
proc
	pre_recycle()
		var/list/L = new/list() // a list of obj paths that should be pre recycled (example below)
		L += typesof(/obj/gore)
		L += typesof(/obj/projectile)
		L += typesof(/mob/npc)
		L += typesof(/obj/item)
		L += /obj/weather/rain
		L += /obj/weather/snow
		L += /obj/weather/bloodrain
		for(var/T in L)
			var/objectPool/sub_type/O = new/objectPool/sub_type
			for(var/i = 1, i <= ORECYCLE, i++) O.npool += new T
			garbage.pool[T] = O



objectPool
	sub_type
		var/npool[0]

	main_type
		var/pool[0]


		proc
			Add(atom/movable/A)
				var/objectPool/sub_type/R = src.pool[A.type]
				if(R)
					if(!(A in R.npool))
						R.npool += A
				else
					src.pool[A.type] = new/objectPool/sub_type
					R = src.pool[A.type]
					if(A)
						if(!(A in R.npool))
							R.npool += A


			Grab(var/type)
				var/atom/G = null
				var/objectPool/sub_type/A = src.pool[type]
				if(A)
					if((A.npool.len > 0))
						G = A.npool[1]
						A.npool -= G
					else G = new type
				else
					src.pool[type] = new/objectPool/sub_type
					G = new type
				return G