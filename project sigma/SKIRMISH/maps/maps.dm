

var
	list/available_maps	= newlist(/map/streetside) //, /map/evacuate, /map/confined)

map
	var
		name
		desc		= "No map info."
		spawn_cap	= 10	// the maximum number of enemies that can be alive at once on the map.
		dmm_file

	test_site011
		name		= "Test Site 011"
		desc		= "A map designed to test various mechanics."
		dmm_file	= 'maps/testing grounds.dmm'
		spawn_cap	= 15

	streetside
		name		= "Streetside"
		desc		= "Larger map inspired by the classic map!"
		dmm_file	= 'maps/streetside.dmm'
		spawn_cap	= 30