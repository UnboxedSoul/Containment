extends Node2D

var laser_visible_time = 200.0
var last_shot=0
export (Color) var LASER_COLOR=Color(1.0,0,0,1.0)
export (bool) var on = false

func draw_lasers():
	#for source in get_tree().get_nodes_in_group("source"):
	#	if(source.get_parent().visible):
	#		if(self.is_firing and self.has_node(source.get_path())):
	if(on):
		draw_line( #Vector2(0,0),
			   $Start.position,				#from point
			   $End.position, 				#to point
			   LASER_COLOR, 										#Line Color
			   2.0, #Line width
			   false)

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

