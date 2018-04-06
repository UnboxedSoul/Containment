extends "res://Towers/Tower.gd"


var laser_shot=-1
var cur_target


func _ready():
	set_process(true)

func _process(delta):
	update()
	if(AvailableTargets.size()>0):
		aim_at(AvailableTargets[0].global_position)

func aim_at(target_pos):
	var aim = global_position.angle_to_point(target_pos)-deg2rad(90)
	rotation=aim

func _on_SensorRange_area_entered( area ):
	AvailableTargets.append(area)

func _on_SensorRange_area_exited( area ):
	var area_index = AvailableTargets.find(area)
	if(area_index!=-1):
		AvailableTargets.remove(area_index)

func _draw():
	var laser_visible_time = 200.0
	var cur_time = OS.get_ticks_msec()
	var time_since_shot = float(cur_time-laser_shot)
	if(cur_target and cur_target.get_ref() and OS.get_ticks_msec()-laser_shot < laser_visible_time):
		var laser_alpha = (laser_visible_time-time_since_shot)/laser_visible_time
		LASER_COLOR.a=laser_alpha
		draw_line(Vector2(0,0),self.to_local(cur_target.get_ref().global_position),LASER_COLOR,2.0,false)

func fire_at(target):
	if(target.get_ref()):
		cur_target=target
		if(target.get_ref().get_parent().damage(DAMAGE)):
			get_parent().get_parent().add_power(20)

func _on_FireTimer_timeout():
	if(AvailableTargets.size()>0):
		laser_shot=OS.get_ticks_msec()
		fire_at(weakref(AvailableTargets[0]))