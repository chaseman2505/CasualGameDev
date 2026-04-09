extends Button


var original_size := scale
var grow_size := Vector2(1.1,1.1)

@export_file("*.tscn") var level_path: String




# Called when the node enters the scene tree for the first time.
func grow_btn(end_size: Vector2, duration: float) -> void:
 var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
 tween.tween_property(self, 'scale', end_size, duration)


func _on_mouse_entered() -> void:
 grow_btn(grow_size, .1)


func _on_mouse_exited() -> void:
 grow_btn(original_size, .1)


func _on_pressed() -> void:
 get_tree().change_scene_to_file(level_path)
 
