

var
	list/available_maps	= newlist(/map/streetside) //, /map/evacuate, /map/confined)

map
	var
		name
		desc	= "No map info."
		dmm_file


	streetside
		name		= "Streetside"
		desc		= "A fresh take on a classic map!"
		dmm_file	= 'maps/streetside.dmm'

	evacuate
		name		= "Evacuate"
		desc		= "Frantic gameplay across a downtown intersection with the enemy coming from all around!"
		dmm_file	= 'maps/evacuate.dmm'

	confined
		name		= "Confined"
		desc		= "Small, close-quarters map that will test your mobility!"
		dmm_file	= 'maps/Confined.dmm'