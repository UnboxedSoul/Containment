extends Node2D

export var sight_range = 200
export var rot_speed = .1
var AvailableTargets = []
export var DAMAGE=10
export var COST=20
export (Color) var LASER_COLOR=Color(1.0,0,0,1.0)

func _ready():
	$tower/targetting_laser.cast_to =Vector2(0,-sight_range)

func get_tower_sprite():
	return $tower.texture

