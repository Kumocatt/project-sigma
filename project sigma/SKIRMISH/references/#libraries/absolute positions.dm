//	Kaiochao
//	11 Jan 2014
//	Absolute Positions
//	Last update: 7 Oct 2014

//	This library is a set of procs for finding, setting,
//	and shifting the absolute pixel positions of atoms.

//	(0, 0) is the bottom-left pixel of the map.
//	You can get the other corners using the map_width() and map_height() procs
//	from the map info library that this one uses.

atom
	proc
		//	The absolute coordinates of this atom's bottom-left corner,
		//	+ a percentage of the atom's dimensions.
		Px(Pc) return (x - 1 + Pc) * tile_width()
		Py(Pc) return (y - 1 + Pc) * tile_height()

		//	The absolute coordinates of this atom's center.
		Cx() return Px(0.5)
		Cy() return Py(0.5)


	movable
		//	Movables require a little bit extra, compared to statics.
		Px(Pc) return (x - 1) * tile_width()  + bound_x + step_x + Pc * bound_width
		Py(Pc) return (y - 1) * tile_height() + bound_y + step_y + Pc * bound_height


		var tmp
			//	Accumulated decimal parts.
			__dec_x
			__dec_y

			//	The direction to the last object bumped.
			bump_dir = 0

		//	This allows you to use decimal values for StepX and StepY
		//	when you call Move().
		Move(Loc, Dir, StepX, StepY)
			var rx = round(StepX)
			var ry = round(StepY)
			__dec_x += StepX - rx
			__dec_y += StepY - ry
			while(__dec_x < -0.5) { __dec_x ++; rx -- }
			while(__dec_x >= 0.5) { __dec_x --; rx ++ }
			while(__dec_y < -0.5) { __dec_y ++; ry -- }
			while(__dec_y >= 0.5) { __dec_y --; ry ++ }
			var dx1 = rx - step_x
			var dy1 = ry - step_y
			var cx = Cx()
			var cy = Cy()
			. = ..(Loc, Dir || dir, rx, ry)
			var dx2 = Cx() - cx
			var dy2 = Cy() - cy
			bump_dir = 0
			if(dx2 != dx1) bump_dir |= dx1 > 0 ? EAST : WEST
			if(dy2 != dy1) bump_dir |= dy1 > 0 ? NORTH : SOUTH

		proc
			SetLoc(atom/Loc, StepX, StepY)
				loc = Loc
				if(!isnull(StepX) && !isnull(StepY))
					step_x = StepX
					step_y = StepY

			//	Set the bottom-left corner to an absolute pixel position.
			//	Like Px() and Py(), you can set the position of a point that is
			//	a percentage of the object's dimensions from its corner.
			SetPosition(X, Y, Z, Pcx, Pcy)
				if(isloc(X))
					var atom/a = X
					X = a.Px()
					Y = a.Py()
					Z = a.z
				if(Pcx) X -= Pcx * bound_width
				if(Pcy) Y -= Pcy * bound_height
				if(isnull(Z)) Z = z
				loc = null
				if(Z)
					var tile_width = tile_width()
					var new_x = X / tile_width + 1
					if(new_x in 0 to world.maxx + 1)
						var tile_height = tile_height()
						var new_y = Y / tile_height + 1
						if(new_y in 0 to world.maxy + 1)
							SetLoc(
								locate(new_x, new_y, Z),
								X % tile_width - bound_x,
								Y % tile_height - bound_y)
							__dec_x = X - round(X)
							__dec_y = Y - round(Y)

			//	Set the center of this mover to an absolute pixel position.
			SetCenter(X, Y, Z)
				if(isloc(X))
					var atom/a = X
					X = a.Cx()
					Y = a.Cy()
					Z = a.z
				SetPosition(X, Y, Z, 0.5, 0.5)

			//	Shift the mover's position by a certain in the x and y axes,
			//	taking obstacles into account along the line of movement.
			//	It's important to set the step_size to something that isn't
			//	smaller than the move itself, so that the move will be a shift
			//	rather than a jump.
			Translate(Dx, Dy, Dir = 0)
				if(!(Dx || Dy)) return

				// also accepts Translate(list(Dx, Dy), Dir)
				if(!isnum(Dx) && istype(Dx, /list))
					Dir = Dy
					Dy = Dx[2]
					Dx = Dx[1]

				// Force a "slide" instead of a "jump"
				// see DM Reference: Move (movable atom)
				var pre_step_size = step_size
				step_size = max(abs(Dx), abs(Dy)) + 1
				. = Move(loc, Dir, step_x + Dx, step_y + Dy)
				step_size = pre_step_size

			//	Shift the mover's position by a certain distance and angle.
			//	Angle increases clockwise from NORTH.
			//	It's convenient for projectiles, but you would actually
			//	be better off storing a vector to Translate() by, in the
			//	case of an object moving with a constant velocity
			//	every frame.
			Project(Distance, Angle, Dir = 0)
				if(!Distance) return
				return Translate(Distance * sin(Angle), Distance * cos(Angle), Dir)