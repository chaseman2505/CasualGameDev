extends Area2D


@onready var beam_container = $BeamContainer
@onready var overlay = $LevelSelectOverlay



func trigger_beam(click_pos: Vector2):
	beam_container.global_position = click_pos
	
	for effect in beam_container.get_children():
		if "emitting" in effect:
			effect.restart()
			effect.emitting = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("workin")
		
		if !overlay.visible:
			print("workin")
			trigger_beam(event.global_position)
