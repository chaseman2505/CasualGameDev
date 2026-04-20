extends Node

var camera: Camera2D

var shake_strength := 0.0
var shake_decay := 5.0

var noise := FastNoiseLite.new()
var noise_time := 0.0

func _ready():
	noise.seed = randi()
	noise.frequency = 20.0

func _process(delta):
	if camera == null:
		return
	
	if shake_strength > 0:
		noise_time += delta * 20
		
		var offset_x = noise.get_noise_2d(noise_time, 0) * shake_strength
		var offset_y = noise.get_noise_2d(0, noise_time) * shake_strength
		
		camera.offset = Vector2(offset_x, offset_y)
		
		# decay
		shake_strength = lerp(shake_strength, 0.0, delta * shake_decay)
	else:
		camera.offset = Vector2.ZERO
		
#public screen shake func
func shake(strength: float = 10.0, decay: float = 5.0):
	shake_strength = max(shake_strength, strength)
	shake_decay = decay
