extends Button


@export var board: Node2D
var level_path: String


var original_size := scale
var grow_size := Vector2(.4,.4)

func grow_btn(end_size: Vector2, duration: float) -> void:
 var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
 tween.tween_property(self, 'scale', end_size, duration)


func _on_mouse_entered() -> void:
 grow_btn(grow_size, .1)


func _on_mouse_exited() -> void:
 grow_btn(original_size, .1)

func _process(delta: float) -> void:
 level_path = Messenger.current_level

func _on_pressed() -> void:
  
  board._spawnBoard(level_path)
  
