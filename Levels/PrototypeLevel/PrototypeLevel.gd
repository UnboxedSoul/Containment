extends Node2D

export (PackedScene) var spider_bot
export (PackedScene) var tower_menu

var paths = []
var MAX_HEALTH=20.0
var health=MAX_HEALTH
export var power=50
var cur_wave=-1
export var waves = [5,10,15,20,50,100] #Each one is the number of enemies in that wave
export var wave_spawn_delays = [1,1,.5,.5,.25,.25]
var num_enemies = 0
var enemy_count = 0

func _ready():
	paths.append($Path/PathFollow2D)
	paths.append($Path2/PathFollow2D)
	globals.energy=power
	update_hud()
	add_tower_points()
	set_process(true)

func add_tower_points():
	for y in range(0,15):
		for x in range(0,15):
			if($TileMap.get_cell(x,y)==12):
				var new_tower_spawn = tower_menu.instance()
				new_tower_spawn.set_position($TileMap.map_to_world(Vector2(x,y),false)+Vector2(32,32))
				add_child(new_tower_spawn)

func update_hud():
	$HUD.update_display(cur_wave+1, globals.energy, health/MAX_HEALTH)

func add_power(amt):
	globals.energy+=amt
	update_hud()

func _process(delta):
	update_hud()
	if(enemy_count <= 0):
		$btnStartWave.show()
	else:
		$btnStartWave.hide()
		
func _on_SpawnTimer_timeout():
	if(num_enemies>0):
		var new_spider = spider_bot.instance()
		$Path/PathFollow2D.set_offset(0)
		new_spider.set_position($Path/PathFollow2D.position)
		new_spider.path=paths[randi()%2]
		add_child(new_spider)
		num_enemies-=1
	else:
		$SpawnTimer.stop()
		$btnStartWave.show()
		#$StartTimer.start()

func _on_ExitZone_area_entered( area ):
	health-=1
	update_hud()

func _on_StartTimer_timeout():
	cur_wave+=1
	if(cur_wave<waves.size()):
		num_enemies = waves[cur_wave]
		$SpawnTimer.wait_time=wave_spawn_delays[cur_wave]
		update_hud()
		$SpawnTimer.start()

func _on_btnStartWave_pressed():
	cur_wave=clamp(cur_wave+1,0,waves.size()-1)
	if(cur_wave<waves.size()):
		StartNewWave()
		num_enemies = waves[cur_wave]
		$SpawnTimer.wait_time=wave_spawn_delays[cur_wave]
		update_hud()
		$SpawnTimer.start()
	
		
func StartNewWave():
	num_enemies = 0
	enemy_count = waves[cur_wave]
