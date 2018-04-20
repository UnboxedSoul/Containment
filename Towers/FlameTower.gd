extends "res://Towers/Tower.gd"

export var EFFECT_INTENSITY=0.5
export var EFFECT_DURATION=1.5
var laser_shot=-1
var cur_target_index=0
var cur_target
var is_firing=false

func increment_target():
	if(AvailableTargets.size()>0):
		cur_target_index+=1
		if(cur_target_index>=AvailableTargets.size()):
			cur_target_index=0
		aim_at(AvailableTargets[cur_target_index].global_position)


func _ready():
	set_process(true)

func _process(delta):
	update()
	

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
		LASER_COLOR.a=laser_alpha*.6
		draw_line(Vector2(0,0),self.to_local(cur_target.get_ref().global_position),LASER_COLOR,12.0,false)
		LASER_COLOR.a=laser_alpha*.8
		draw_line(Vector2(0,0),self.to_local(cur_target.get_ref().global_position),LASER_COLOR,8.0,false)
		LASER_COLOR.a=laser_alpha*.9
		draw_line(Vector2(0,0),self.to_local(cur_target.get_ref().global_position),LASER_COLOR,2.0,false)
		LASER_COLOR.a=laser_alpha
		draw_line(Vector2(0,0),self.to_local(cur_target.get_ref().global_position),LASER_COLOR,1.0,false)


func fire_at(target):
	if(target.get_ref()):
		var target_obj = target.get_ref().get_parent()
		cur_target=target
		target_obj.burn_for(DAMAGE*level)
		#if():
		#	get_parent().get_parent().add_power(20)

func control_flames(is_on):
	for flame in get_tree().get_nodes_in_group("flame"):
		is_firing=is_on
		if(is_on):
			if(flame.get_parent().visible):
				flame.show()
		else:
			flame.hide()
			


func _on_FireTimer_timeout():
	if(AvailableTargets.size()>0 and cur_target_index < AvailableTargets.size()):
		laser_shot=OS.get_ticks_msec()
		fire_at(weakref(AvailableTargets[cur_target_index]))
		control_flames(true)
		$FlameController.start()


func _on_FlameController_timeout():
	control_flames(false)

func _on_BurnTimer_timeout():
	if(is_firing and AvailableTargets.size()>0):
		print("Burning target")
		if($tower/targetting_laser.is_colliding()):
			print("Actually have a target")
		fire_at(weakref(AvailableTargets[0]))
	pass # replace with function body


func _on_TargetTimer_timeout():
	increment_target()
	pass # replace with function body
