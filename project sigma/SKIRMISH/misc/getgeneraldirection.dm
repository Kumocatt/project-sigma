


proc/get_general_dir(atom/ref,atom/target)
    if(target.z > ref.z) return UP
    if(target.z < ref.z) return DOWN

    var/d = get_dir(ref,target)
    if(d&d-1)        // diagonal
        var/ax = abs(ref.x - target.x)
        var/ay = abs(ref.y - target.y)
        if(ax >= (ay << 1))      return d & (EAST|WEST)   // keep east/west (4 and 8)
        else if(ay >= (ax << 1)) return d & (NORTH|SOUTH) // keep north/south (1 and 2)
    return d


