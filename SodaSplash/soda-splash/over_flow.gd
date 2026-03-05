extends GPUParticles2D
@export var offset = 0.0
var bar: TextureProgressBar
@export var minWidth = 0.0


func _ready():
	
	bar = get_parent()
	
	
func _process(_delta):
	update_behavior()
	


func update_behavior():
	if bar.value > 100:
		z_index = 3
		
		lifetime = 1.95
	else:
		
		z_index = 0
		lifetime = 0.25
	
	var fill_ratio = (bar.value - bar.min_value) / (bar.max_value - bar.min_value)
	
	var available_height = bar.size.y - offset
	var target_y = bar.size.y - (available_height * fill_ratio) - offset
	var target_x = bar.size.x/2
	
	position = Vector2(target_x,target_y)
	
	emitting = bar.value > bar.min_value
	
