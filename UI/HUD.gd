extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
func update_display(wave, currency, healthPct=1):
	$lblWave.text="Wave: %s" % wave
	$lblPower.text=str(currency)
	$Health.modulate.a=healthPct