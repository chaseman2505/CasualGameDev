extends Node2D

@onready var particles = $SunBeam
@onready var particles2 = $SunImpact2

func _input(event):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		particles.global_position = get_global_mouse_position()
		
		particles.restart()
		particles.emitting = true
		
		particles2.global_position = get_global_mouse_position()
		
		particles2.restart()
		particles2.emitting = true
