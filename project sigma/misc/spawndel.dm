atom
	proc
		spawndel(t)
			set waitfor = 0
			sleep t
			animate(src, alpha = 0, time = 2)
			sleep 2
			if(!src || ! loc) return
			if(ismob(src) || isobj(src))
				var/atom/movable/a = src
				if(a.is_garbage)
					a.GC()
					return
			del src