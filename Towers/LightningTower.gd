extends "res://Towers/Tower.gd"


var laser_shot=-1
var cur_target
var is_firing=false
var arc_source = load("res://Towers/beams/LightningArcSource.tscn")

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
	#Turret1
	$tower/turret/LightningBolt.set_end(target_pos)
	$tower/turret2/LightningBolt.set_end(target_pos)
	$tower/turret3/LightningBolt.set_end(target_pos)


func _on_SensorRange_area_entered( area ):
	AvailableTargets.append(area)

func _on_SensorRange_area_exited( area ):
	var area_index = AvailableTargets.find(area)
	if(area_index!=-1):
		AvailableTargets.remove(area_index)

func fire():
	$tower/turret/LightningBolt.fire(200.0)
	$tower/turret2/LightningBolt.fire(200.0)
	$tower/turret3/LightningBolt.fire(200.0)

func fire_at(target):
	if(target.get_ref()):
		fire()
		cur_target=target
		target.get_ref().get_parent().damage(DAMAGE*level)
		#Add an arc source
		var new_arc = arc_source.instance()
		new_arc.dmg = DAMAGE*level
		new_arc.src = cur_target
		target.get_ref().get_parent().add_child(new_arc)
		new_arc.arc()

func _on_FireTimer_timeout():
	if(AvailableTargets.size()>0):
		laser_shot=OS.get_ticks_msec()
		is_firing=true
		fire_at(weakref(AvailableTargets[0]))