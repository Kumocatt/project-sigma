//	Kaiochao
//	11 Jan 2014
//	Map Info

//	Updated 27 Feb 2014

//	This is a collection of procs to be used to get information about the world.

/*

	Proc List

	(global)

	Pixel size of a tile (from world.icon_size)
	tile_width()
	tile_height()

	Pixel size of the map (from world.maxx and maxy)
	map_width()
	map_height()


	(client)

	Tile size of the client's view
	ViewWidth()
	ViewHeight()

	Pixel size of the client's view
	ViewWidthPx()
	ViewHeightPx()

*/


//	These vars exist so that math is not repeated if the world hasn't changed.
//	Do not use these in your code.
var
	__tile_width
	__tile_height

	__map_width
	__map_height

	__maxx
	__maxy

//	Use these procs.
proc
	//	The width of a tile, from world.icon_size
	tile_width()
		if(!__tile_width)
			if(isnum(world.icon_size))
				__tile_width = world.icon_size
			else if(istext(world.icon_size))
				__tile_width = text2num(world.icon_size)
		return __tile_width

	//	The height of a tile, from world.icon_size
	tile_height()
		if(!__tile_height)
			if(isnum(world.icon_size))
				__tile_height = world.icon_size
			else if(istext(world.icon_size))
				__tile_height = text2num(copytext(world.icon_size, findtext(world.icon_size, "x") + 1))
		return __tile_height

	//	The width of the map in pixels
	map_width()
		if(world.maxx != __maxx)
			__maxx = world.maxx
			__map_width = world.maxx * tile_width()
		return __map_width

	//	The height of the map in pixels
	map_height()
		if(world.maxy != __maxy)
			__maxy = world.maxy
			__map_height = world.maxy * tile_height()
		return __map_height

client
	var tmp/__view
	var tmp/__view_width
	var tmp/__view_height
	var tmp/__view_widthpx
	var tmp/__view_heightpx

	proc/__ViewChanged()
		if(isnum(view))
			__view_width = view * 2 + 1
			__view_height = __view_width
		else
			__view_width = text2num(view)
			__view_height = text2num(copytext(view, findtext(view, "x") + 1))
		__view_widthpx = __view_width * tile_width()
		__view_heightpx = __view_height * tile_height()

	#define _(x) { if(view != __view) { __view = view; __ViewChanged()} return x }
	proc/ViewWidth() _(__view_width)
	proc/ViewHeight() _(__view_height)
	proc/ViewPixelWidth() _(__view_widthpx)
	proc/ViewPixelHeight() _(__view_heightpx)
	#undef _
