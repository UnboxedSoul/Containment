extends Node2D
export (Array) var towers
var empty_button_texture = preload("res://UI/nothing.png")
var tower
var creatingTower = false

func hide_menu():
	if(globals.menu_visible):
		globals.menu_visible=false
		z_index=0
		$MenuTimeout.stop()
		$AnimationPlayer.play("hide_menu")
		remove_tower_buttons()

func show_menu():
	if(!globals.menu_visible):
		globals.menu_visible=true
		z_index=10
		$MenuTimeout.start()
		$AnimationPlayer.play("show_menu")

func _ready():
	pass

func spawn_tower(t):
	tower=t.instance()
	if(tower.COST<=get_parent().power):
		add_child(tower)
		hide_menu()
		get_parent().add_power(-tower.COST)
	else:
		tower.queue_free()
		tower=null
		
	
func create_tower_buttons():
	if(!creatingTower):
		creatingTower = true
		var i = 0
		for tower in towers:
			i+=1
			var tower_button=TextureButton.new()
			tower_button.texture_normal=empty_button_texture
			$btnAdd.add_child(tower_button)
			var tower_sprite = Sprite.new()
			tower_sprite.centered=false
			tower_sprite.texture=tower.instance().get_tower_sprite()
			tower_sprite.set_position(Vector2(16,8))
			tower_sprite.scale = Vector2(1.5,1.5)
			tower_button.add_child(tower_sprite)
			#Add cost labels
			var cost_label = load('res://UI/CostLabel.tscn').instance()
			cost_label.text = str(tower.instance().COST)
			tower_button.add_child(cost_label)
			var tower_position = Vector2(132*cos(deg2rad((30)*i-90)),132*sin(deg2rad((30)*i-90)))
			tower_button.set_position(tower_position)
			tower_button.connect("pressed",self,"spawn_tower",[tower])
		

func remove_tower_buttons():
	creatingTower = false
	for c in $btnAdd.get_children():
		$btnAdd.remove_child(c)
		c.queue_free()
	

func _on_btnRaiseMenu_pressed():
	show_menu()

func _on_MenuTimeout_timeout():
	hide_menu()

func _on_btnAdd_pressed():
	#hide_menu()
	if(!tower):
		create_tower_buttons()

func _on_btnRemove_pressed():
	if(tower):
		tower.queue_free()
		tower=null
	hide_menu()

func _on_btnUpgrade_pressed():
	if(tower):
		if(tower.COST<=get_parent().power):
			if(tower.level_up()):
				get_parent().add_power(-tower.COST)
	hide_menu()