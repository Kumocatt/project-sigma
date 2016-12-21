#define TILE_WIDTH 16
#define TILE_HEIGHT 16
#define MAX_VIEW_TILES 195

#define floor(x) round(x)
#define ceil(x) (-round(-x))

client
    var
        view_width
        view_height
        map_zoom
    verb
        onResize()
            set hidden = 1
            set waitfor = 0
            var/sz = winget(src,"map1","size")
            var/map_width = text2num(sz)
            var/map_height = text2num(copytext(sz,findtext(sz,"x")+1,0))
            map_zoom = 1
            view_width = ceil(map_width/TILE_WIDTH)
            if(!(view_width%2)) ++view_width
            view_height = ceil(map_height/TILE_HEIGHT)
            if(!(view_height%2)) ++view_height

            while(view_width*view_height>MAX_VIEW_TILES)
                view_width = ceil(map_width/TILE_WIDTH/++map_zoom)
                if(!(view_width%2)) ++view_width
                view_height = ceil(map_height/TILE_HEIGHT/map_zoom)
                if(!(view_height%2)) ++view_height

            src.view = "[view_width]x[view_height]"
            winset(src,"map1","zoom=[map_zoom];")

mob
	Login()
		winset(src,"default","size=832x640")
		client.onResize()
		return ..()

	Logout()
		..()
		del(src)