
/*

derpy derpy doo

*/

mob/player
	proc
		draw_planes()
			client.screen += new/obj/lighting_plane
			draw_spotlight(-38, -38, "#404040")


atom/movable
	var
		image/spotlight	// null by default because not everything will have one, obvi
	proc
		draw_spotlight(x_os = 0, y_os = 0, hex = "#404040")
			/* x_offset, y_offset, color value (if any)
				*/
			spotlight 			= new /image/spotlight
			spotlight.pixel_x	= x_os
			spotlight.pixel_y	= y_os
			spotlight.color		= hex
			overlays += spotlight


obj/lighting_plane												// add this to the client's screen     This and the below comment are both done in the above proc
	screen_loc 			= "1,1"
	plane 				= 1
	blend_mode 			= BLEND_MULTIPLY
	appearance_flags 	= PLANE_MASTER | NO_CLIENT_COLOR
	mouse_opacity 		= 0


image/spotlight															// SyX add this to the player's overlays.
	plane 			= 1
	blend_mode 		= BLEND_ADD
	icon 			= 'lighting.dmi'  // a 96x96 white circle
	icon_state 		= "0"
	pixel_x 		= -38
	pixel_y 		= -38
	layer			= 1+EFFECTS_LAYER
	appearance_flags= RESET_COLOR


