
proc/Get_Angle(atom/ref,target_x,target_y,pix_x,pix_y)
  //First you have to find the distance between
  // the ref and the object.
  var/dx = (target_x + pix_x/32) - (ref.x + ref.pixel_x/32)
  var/dy = (target_y + pix_y/32) - (ref.y + ref.pixel_y/32)
  //Then the angle equals arctan(distx/disty):
  return arctan(dx,dy)

proc/arctan(x,y) //From Lummox
  return (y>=0)?(arccos(x/sqrt(x*x+y*y))):(-arccos(x/sqrt(x*x+y*y)))










/*

	BYOND Angular Reference

	BYOND's built-in procs take two different kinds of angles.
		cos() and sin() take angles, while
		icon.Turn() and turn() take bearings.

		Angles increase counterclockwise and start from 0 = EAST.
		Bearings increase clockwise and start from 0 = NORTH.

	Your silly arrow icons start with 0 = EAST and increases clockwise.

*/

//	Returns an anglek
var
	paused
	has_AI1
	has_AI2
	has_AI3
	has_AI4
proc/getplayerkeys(k)
	return k
proc/katan2(x, y) return (x || y) && (x >= 0 ? arccos(y / sqrt(x * x + y * y)) : 360 - arccos(y / sqrt(x * x + y * y)))
proc/atan2(x, y)
	if(!(x || y)) return 0
	. = arccos(x / sqrt(x * x + y * y))
	if(y < 0) . = 360 - .
	return clamp_angle(.)

//	Returns a bearing
proc/atan2b(x, y)
	return angle2bearing(atan2(x, y))

//	This would be your replacement.
proc/kget_angle(atom/a, atom/b)
	if(b && a)
		return atan2(
			(b.px(0.5)+b.x_offset) - (a.px(0.5)+a.x_offset),
			(b.py(0.5)+b.y_offset) - (a.py(0.5)+a.y_offset))
proc/vector2dangle(ax,ay,bx,by)
	return -(atan2((bx) - (ax),(by) - (ay)))+90

atom
	var/tmp/
		x_offset=0
		y_offset=0

proc/tkget_angle(atom/a, atom/b)
	return atan2(
		b.px(0.5) - a.px(0.5),
		b.py2(0.5) - a.py(0.5))
//	This is standard pixel movement stuff, for me.
var const/tile_width = 16
var const/tile_height = 16

proc/clamp_angle(angle)
	. = angle
	while(. >= 360) . -= 360
	while(. <    0) . += 360

proc/angle2bearing(angle)
	if(isnum(angle))

		return clamp_angle(90 - angle)
	else
		return 0
proc/bearing2angle(bearing)
	return angle2bearing(bearing)

//	The + 90 accounts for your silly arrow icons.
proc/angle2state(angle)
	return "[clamp_angle(round(angle2bearing(angle) + 90, 1))]"
proc/main_dir(d) switch(d)
	if(NORTH)		return 1
	if(SOUTH)		return 1
	if(EAST)		return 1
	if(WEST)		return 1

proc/dir2text2(d) switch(d)
	if(NORTH)		return "north"
	if(SOUTH)		return "south"
	if(EAST)		return "east"
	if(WEST)		return "west"

	if(NORTHEAST)	return null
	if(SOUTHEAST)	return null
	if(NORTHWEST)	return null
	if(SOUTHWEST)	return null

proc/dir2angle(dir) switch(dir)
	if(NORTH)		return 90
	if(SOUTH)		return 270
	if(EAST)		return 0
	if(WEST)		return 180
	if(NORTHEAST)	return 45
	if(SOUTHEAST)	return 315
	if(NORTHWEST)	return 135
	if(SOUTHWEST)	return 225
proc/angle2dir(angle)
	angle = clamp_angle(angle)
	var/L = list(1,5,4,6,2,10,8,9)
	var/X = round(angle,45)/45%8+1
	return L[X]

proc/dir2bearing(dir)
	return angle2bearing(dir2angle(dir))

//	Get the absolute pixel position of anything.
//	p - percentage of the bounding box. (px(0.5), py(0.5)) is the center.*/
atom
	proc/px(p) return tile_width  * (x - 1 + p)
	proc/py(p) return tile_height * (y - 1 + p)
	proc/py2(p) return (tile_height * (y - 1 + p)) + 96
	movable
		px(p) return tile_width  * (x - 1) + bound_x + step_x + p * bound_width
		py(p) return tile_height * (y - 1) + bound_y + step_y + p * bound_height

proc/lerp(a, b, c) return a * (1 - c) + b * c
proc/randn(a, b) return lerp(min(a, b), max(a, b), rand())
proc/sign(n) return n && n / abs(n)

proc/angle_difference(a, b)
	. = clamp_angle(b) - clamp_angle(a)
	if(. < -180) . += 360
	if(. >  180) . -= 360