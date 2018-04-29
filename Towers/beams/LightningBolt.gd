extends Node2D

var laser_visible_time = 200.0
var last_shot=0
export (Color) var LASER_COLOR=Color(1.0,0,0,1.0)
export (bool) var on = false
export (int) var num_nodes = 10.0
export (int) var angle_variance = 30.0

func calc_point_at_dist_angle(point, dist,angle):
	return Vector2(sin(angle)*dist, cos(angle)*dist) + point

func draw_lasers():
	if(on):
		var cur_pos = $Start.position
		var total_distance = cur_pos.distance_to($End.position)
		var node_length = total_distance/num_nodes
		var a = self.global_rotation
		#-self.global_rotation
		for i in range(0,num_nodes):
			#Calculate the angle with variance
			var angle_to_target = cur_pos.angle_to_point($End.position)
			var new_angle = angle_to_target + angle_variance/2.0+ rand_range(-(angle_variance),angle_variance/2.0)
			#Calculate position of the end of the current node
			var end_pos = calc_point_at_dist_angle(cur_pos,node_length,deg2rad(new_angle-180))
			draw_line( #Vector2(0,0),
			   cur_pos,				#from point
			   end_pos, 			#to point
			   LASER_COLOR, 		#Line Color
			   3.0, #Line width
			   false)
			draw_line( #Vector2(0,0),
			   cur_pos,				#from point
			   end_pos, 			#to point
			   LASER_COLOR+Color(.2,.2,.2) , 		#Line Color
			   1.0, #Line width
			   false)
			cur_pos=end_pos
		draw_line( #Vector2(0,0),
		   cur_pos,				#from point
		   $End.position, 			#to point
		   LASER_COLOR, 		#Line Color
		   3.0, #Line width
		   false)
		draw_line( #Vector2(0,0),
		   cur_pos,				#from point
		   $End.position, 			#to point
		   LASER_COLOR+Color(.2,.2,.2,-.5) , 		#Line Color
		   1.0, #Line width
		   false)
		draw_circle($End.position,8,LASER_COLOR+Color(.2,.2,.2,-.75))

func _draw():
	var cur_time = OS.get_ticks_msec()
	var time_since_shot = float(cur_time-last_shot)
	#if(cur_target and cur_target.get_ref() and OS.get_ticks_msec()-last_shot < laser_visible_time):
	var laser_alpha = (laser_visible_time-time_since_shot)/laser_visible_time
	LASER_COLOR.a=laser_alpha
	draw_lasers()

func _ready():
	set_process(true)
	pass
	
func fire(duration):
	laser_visible_time=duration
	on=true
	last_shot=OS.get_ticks_msec()
	$FireTimer.wait_time=(duration/1000.0)
	$FireTimer.start()

func set_start(pos):
	$Start.global_position=pos
func set_end(pos):
	$End.global_position=pos

func _process(delta):
	update()
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_FireTimer_timeout():
	on=false

