extends Node2D

export var sight_range = 200
export var rot_speed = .1
var AvailableTargets = []
export var DAMAGE=10
export var COST=20
export (Color) var LASER_COLOR=Color(1.0,0,0,1.0)
var level=1
export var MAX_LEVEL=3
export (Texture)var icon

func _ready():
	$tower/targetting_laser.cast_to =Vector2(0,-sight_range)

func get_tower_sprite():
	return icon

func level_up():
	if(level+1<=MAX_LEVEL):
		level+=1
		get_node("tower/turret"+str(level)).show()
		return true
	else:
		return false

