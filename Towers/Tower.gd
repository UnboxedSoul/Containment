extends Node2D

export var sight_range = 200
export var rot_speed = .1

func _ready():
	$tower/targetting_laser.cast_to =Vector2(0,-sight_range)

func get_tower_sprite():
	return $tower.texture

