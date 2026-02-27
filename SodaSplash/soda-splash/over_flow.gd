extends GPUParticles2D
@export var fill_indicator: TextureProgressBar
@export var offset_y: float = 0.0
var isOverflow = false





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fill_indicator.value > 100:
		lifetime = 1.95
	else:
		lifetime = 0.2
		
		
		
	var fill_ratio = fill_indicator.value/ fill_indicator.max_value
	var bar_height = fill_indicator.size.y
	var fill_line_y = -(bar_height * fill_ratio/2.5)
	
	var bar_top = fill_indicator.global_position
	global_position.y = bar_top.y*1.6 + fill_line_y
	
