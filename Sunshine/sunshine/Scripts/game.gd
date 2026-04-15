extends Node2D

@onready var beam_container = $BeamContainer

@onready var overlay = $LevelSelectOverlay

func _input(event):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !overlay.visible:
		beam_container.global_position = get_global_mouse_position()
		for effect in beam_container.get_children():
			if "emitting" in effect:
				effect.restart()
				effect.emitting = true
		
