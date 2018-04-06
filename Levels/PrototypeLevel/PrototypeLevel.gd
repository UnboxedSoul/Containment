extends Node2D

export (PackedScene) var spider_bot
export (PackedScene) var tower_menu

var paths = []
var MAX_HEALTH=20.0
var health=MAX_HEALTH
export var power=50
var cur_wave=1
var waves = []

func _ready():
	paths.append($Path/PathFollow2D)
	paths.append($Path2/PathFollow2D)
	update_hud()
	add_tower_points()

func add_tower_points():
	for y in range(0,15):
		for x in range(0,15):
			if($TileMap.get_cell(x,y)==12):
				var new_tower_spawn = tower_menu.instance()
				new_tower_spawn.set_position($TileMap.map_to_world(Vector2(x,y),false)+Vector2(32,32))
				add_child(new_tower_spawn)
				print("Found tower spawn point")

func update_hud():
	$HUD.update_display(cur_wave, power, health/MAX_HEALTH)

func add_power(amt):
	power+=amt
	update_hud()

func _on_SpawnTimer_timeout():
	var new_spider = spider_bot.instance()
	$Path/PathFollow2D.set_offset(0)
	new_spider.set_position($Path/PathFollow2D.position)
	new_spider.path=paths[randi()%2]
	add_child(new_spider)
	$SpawnTimer.wait_time-=1

func _on_ExitZone_area_entered( area ):
	health-=1
	update_hud()
