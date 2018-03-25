extends Node2D
export (Array) var towers
var empty_button_texture = preload("res://UI/empty_button.png")
var tower

func hide_menu():
	z_index=0
	$MenuTimeout.stop()
	$AnimationPlayer.play("hide_menu")
	remove_tower_buttons()

func show_menu():
	z_index=10
	$MenuTimeout.start()
	$AnimationPlayer.play("show_menu")

func _ready():
	hide_menu()
	pass

func spawn_tower(t):
	tower=t.instance()
	add_child(tower)
	hide_menu()
	
func create_tower_buttons():
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
		tower_sprite.scale = Vector2(.75,.75)
		tower_button.add_child(tower_sprite)
		var tower_position = Vector2(132*cos(deg2rad((30)*i-90)),132*sin(deg2rad((30)*i-90)))
		tower_button.set_position(tower_position)
		tower_button.connect("pressed",self,"spawn_tower",[tower])
		

func remove_tower_buttons():
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
	tower.queue_free()
	tower=null
	hide_menu()

func _on_btnUpgrade_pressed():
	hide_menu()