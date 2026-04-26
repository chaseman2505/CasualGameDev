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
 
  
   board._spawnBoard(get_next_level_name(level_path))
   


func get_next_level_name(current_name: String) -> String:
	
 var clean_name = current_name.to_lower().replace(".txt", "").strip_edges()
	
	
 var regex = RegEx.new()
 regex.compile("([a-z]+)(\\d+)")
 var result = regex.search(clean_name)
	
 if not result:
  return current_name

 var prefix = result.get_string(1)
 var current_num = int(result.get_string(2))
 var next_num = current_num + 1
	
	
 var final_name = ""
	
 if prefix == "tutorial" and current_num >= 6:
  final_name = "level1"
 else:
  final_name = prefix + str(next_num)
	
	
 var output = final_name + ".txt"
	
	
 Messenger.broadcast("res://Levels/"+output)
 print("DEBUG: Transitioning from ", current_name, " to ", output)
 return "res://Levels/" +output
