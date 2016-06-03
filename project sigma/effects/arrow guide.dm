//#include <kaiochao/absolutepositions/absolute positions/absolute positions.dme>

mob
	var/tmp
		targeted = 0
	proc/PointArrow(obj/Arrow, atom/Target, MinDistance, ArrowDistance)
		#if DM_VERSION < 509
		if(isnull(MinDistance)) MinDistance = min(client.ViewPixelWidth(), client.ViewPixelHeight()) * (5/8)
		if(isnull(ArrowDistance)) ArrowDistance = min(client.ViewPixelWidth(), client.ViewPixelHeight()) * (3/8)
		#else
		if(isnull(MinDistance)) MinDistance = min(client.bound_width, client.bound_height) * (5/8)
		if(isnull(ArrowDistance)) ArrowDistance = min(client.bound_width, client.bound_height) * (3/8)
		#endif
		var dx = Target.Cx() - Cx()
		var dy = Target.Cy() - Cy()
		var dot = dx*dx + dy*dy
		if(dot < MinDistance * MinDistance)
			Arrow.screen_loc = null
			return
		Arrow.screen_loc = "CENTER"
		var matrix/m = new
		m.Translate(0, ArrowDistance)
		m.Turn(dx > 0 ? arccos(dy / sqrt(dot)) : -arccos(dy / sqrt(dot)))
		Arrow.transform = initial(Arrow.transform) * m

	player
		var/target_arrows[]
		proc
			remove_target(mob/m)
			//	m.targeted = 0
				client.screen -= target_arrows[m]
				target_arrows -= m
				if(!target_arrows.len)
					target_arrows = null

			add_target(mob/m)
				if(m in target_arrows)
					return
				//m.targeted = 1
				if(!target_arrows)
					target_arrows = new
				target_arrows[m] = new /obj/arrow
				client.screen += target_arrows[m]
				// update the arrow every frame
				spawn while(src && (m in target_arrows))
					PointArrow(target_arrows[m], m)
					sleep world.tick_lag





obj/arrow
	icon			= 'effects/arrow.dmi'
	icon_state 		= "arrow"
 //   color 			= "red"
	mouse_opacity 	= FALSE
	plane			= 3
