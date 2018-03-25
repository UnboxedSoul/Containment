extends Node2D

var path
var path_offset=0
var pos_offset=Vector2(32,0)
var dead=false
export var SPEED=100
export var MAX_HEALTH=100.0
var cur_speed=SPEED
var health=MAX_HEALTH

func _ready():
	set_process(true)

func damage(dmg):
	health-=dmg
	$health_bar_green.scale=Vector2(1,health/MAX_HEALTH)
	if(health<=0):
		$AnimatedSprite.play("die")
		dead=true
		$Area2D.queue_free()
		$DecayTimer.start()

func _process(delta):
	if(!dead):
		if(path):
			path_offset+=cur_speed*delta
			path.offset=path_offset
			position = path.position+pos_offset
		else:
			position.x-=cur_speed*delta

func _on_DecayTimer_timeout():
	queue_free()

func _on_EffectTimer_timeout():
	cur_speed=SPEED
