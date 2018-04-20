extends "res://Towers/Tower.gd"


var laser_shot=-1
var cur_target
var is_firing=false


func _ready():
	set_process(true)

func _process(delta):
	update()
	if(AvailableTargets.size()>0):
		aim_at(AvailableTargets[0].global_position)

func aim_at(target_pos):
	var aim = global_position.angle_to_point(target_pos)-deg2rad(90)
	rotation=aim
	#Set all lasers to aim at the target
	for source in get_tree().get_nodes_in_group("source"):
			if(self.has_node(source.get_path())):
				source.set_end(target_pos)

func _on_SensorRange_area_entered( area ):
	AvailableTargets.append(area)

func _on_SensorRange_area_exited( area ):
	var area_index = AvailableTargets.find(area)
	if(area_index!=-1):
		AvailableTargets.remove(area_index)

func fire():
	for source in get_tree().get_nodes_in_group("source"):
			if(self.is_firing and self.has_node(source.get_path())):
				source.fire(200)

func fire_at(target):
	if(target.get_ref()):
		fire()
		cur_target=target
		if(target.get_ref().get_parent().damage(DAMAGE*level)):
			get_parent().get_parent().add_power(20)

func _on_FireTimer_timeout():
	if(AvailableTargets.size()>0):
		laser_shot=OS.get_ticks_msec()
		is_firing=true
		fire_at(weakref(AvailableTargets[0]))