extends Node2D

export var dmg = 0
var src = null
var arc_source = load("res://Towers/beams/LightningBolt.tscn")

func _ready():
	pass
	
func arc():
	var closest_dist = null
	var closest_target = null
	#Find closest target
	for t in $ArcZone.get_overlapping_areas():
		var dist = self.position.distance_to(t.position)
		if(dist<closest_dist or closest_dist is null and t != src):
			closest_dist=dist
			closest_target=t
	#Zap closest target
	if(closest_target!= null):
		$LightningBolt.set_end(closest_target.position)
		print(closest_dist, "To", closest_target)
		closest_target.get_ref().get_parent().damage(dmg*.25)
		$LightningBolt.fire(200)
		#Add an arc source to target
		#Add an arc source
		var new_arc = arc_source.instance()
		new_arc.dmg = dmg*.25
		new_arc.src = closest_target
		closest_target.add_child(new_arc)
		new_arc.arc()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
