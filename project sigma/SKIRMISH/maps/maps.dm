

var
	list/available_maps	= newlist(/map/streetside, /map/hallowed) //, /map/evacuate, /map/confined)

map
	var
		name
		desc		= "No map info."
		spawn_cap	= 10	// the maximum number of enemies that can be alive at once on the map.
		dmm_file

	streetside
		name		= "Streetside"
		desc		= "Classic map with poor design!"
		dmm_file	= 'maps/streetside.dmm'
		spawn_cap	= 30

	hallowed
		name		= "Hallowed"
		desc		= "Large map set in a forest graveyard; what secrets lay hidden in the crypt?"
		dmm_file	= 'maps/hallowed.dmm'
		spawn_cap	= 45