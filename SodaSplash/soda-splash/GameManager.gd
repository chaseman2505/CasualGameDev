extends Node2D

@onready var static_body = get_node("StaticBody2D4")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print("Left mouse held")
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				#static_body.scale.x = 30
				static_body.position = Vector2(-500, 500)
				#print("Left mouse button pressed")
			else:
				#static_body.scale.x = 50
				static_body.position = Vector2(-134, 53)
