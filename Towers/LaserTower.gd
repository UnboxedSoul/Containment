extends "res://Towers/Tower.gd"


var laser_shot=-1
var cur_target
var is_firing=false
var _delta

func _ready():
	set_process(true)

func _process(delta):
	_delta = delta

	update()
	if(AvailableTargets.size()>0):
		aim_at(AvailableTargets[0].global_position)

func aim_at(target_pos):
	var aim = global_position.angle_to_point(target_pos)-deg2rad(90)
	rotation = aim
	#Set all lasers to aim at the target
	#Turret1
	$tower/turret/LaserBeam.set_end(target_pos)
	$tower/turret2/LaserBeam.set_end(target_pos)
	$tower/turret3/LaserBeam.set_end(target_pos)

func _on_SensorRange_area_entered( area ):
	AvailableTargets.append(area)

func _on_SensorRange_area_exited( area ):
	var area_index = AvailableTargets.find(area)
	if(area_index!=-1):
		AvailableTargets.remove(area_index)

func fire():
	$ShootSound.play()
	$tower/turret/LaserBeam.fire(200.0)
	$tower/turret2/LaserBeam.fire(200.0)
	$tower/turret3/LaserBeam.fire(200.0)

func fire_at(target):
	if(target.get_ref()):
		fire()
		cur_target=target

		if(target.get_ref().get_parent().health > 0):
			target.get_ref().get_parent().damage(DAMAGE*level)
		#if():
		#	get_parent().get_parent().add_power(20)

func _on_FireTimer_timeout():
	if(AvailableTargets.size()>0):
		laser_shot=OS.get_ticks_msec()
		is_firing=true
		fire_at(weakref(AvailableTargets[0]))