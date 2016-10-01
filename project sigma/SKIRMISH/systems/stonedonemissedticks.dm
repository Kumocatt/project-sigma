var
	worldstarttime = 0
	worldstarttimeofday = 0
client
	Stat()
		if (!worldstarttime || worldstarttimeofday)
			worldstarttime = world.time
			worldstarttimeofday = world.timeofday
		var/tickdrift = (worldstarttimeofday - world.timeofday) - (worldstarttime - world.time)  / world.tick_lag
		statpanel("Tick Drift", "[round(tickdrift)] Missed ticks")
		..()