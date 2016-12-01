atom/movable

	var/o_transform
	var/shake_amount=1
	proc

		//a is the angle the blood flies at, if there is no angle then it flies in random directions. this is the only parameter you should consider changing
		//for example:
		// src.blood(null,getAngle(src,bullet))
		// src.shake()

		//this effect will look nice

		//i is the alternate icon state for the blood
		//c is the alternate color for the blood
		//n is the size of the blood

		shake()

			var/matrix/M = matrix()
			if(o_transform)
				M = matrix(o_transform)

			animate(src,transform = turn(M*(rand(8,12)*0.1),rand(-5,5)*shake_amount),pixel_y = rand(-3,3)*shake_amount,pixel_x = rand(-3,3)*shake_amount,time=1)
			animate(transform = turn(M*(rand(8,12)*0.1),rand(-5,5)*shake_amount),pixel_y = rand(-3,3)*shake_amount,pixel_x = rand(-3,3)*shake_amount,time=1)
			animate(transform = M,pixel_y=0,pixel_x=0,time=1)

		death_animation()
			spawn()
			//	shake()
				animate(src,transform = turn(transform,pick(-90,90)), time=4,easing = BOUNCE_EASING)
				if(!is_explosive)
					sleep 4
					animate(src, alpha = 0, time = 2)
				for(var/i=0,i<4,i++)
					blood()
					sleep 1

		blood(n=1)
			for(var/i3 = 0, i3 < rand(4, 8), i3++)
				var/obj/O 		= new/obj()
				O.x				= x
				O.y				= y
				O.z				= z
				O.step_x 		= step_x + bound_x + (bound_width/2) - 8
				O.step_y 		= step_y + bound_y + (bound_height/2) - 2
				O.icon 			= 'gore.dmi'
				O.icon_state 	= "blood[pick(5,10)]"
				var/matrix/M 	= matrix()
				if(prob(15))
					O.icon_state	= "gut[rand(1,5)]"
					O.layer			= TURF_LAYER+0.16
				else O.layer 		= TURF_LAYER+0.15
				var/A = rand(1,360)
				var/R = (n * (rand(5,15) * 0.1))
				M.Scale(R,R*0.75)
				O.transform = matrix()*0.1
				var/PY = rand(32,64)
				var/PX = rand(16,48)
				O.alpha=0
				animate(O,transform = M,pixel_y = sin((-A)+90)*(PY),pixel_x = cos((-A)+90)*(PX/2),pixel_z = rand(8,16),alpha=255,time=2,easing = SINE_EASING)
				animate(pixel_y = O.pixel_y+(sin((-A)+90)*(PY/2)),pixel_x = O.pixel_x + (cos((-A)+90)*(PX/2)),pixel_z=0,time=1)
				animate(pixel_y =sin((-A)+90)*(PY/2), time=1,easing = SINE_EASING)
				animate(pixel_y =sin((-A)+90)*(PY/2), transform = matrix(), time=10)
				O.spawndel(80)

