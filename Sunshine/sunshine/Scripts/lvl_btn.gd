extends Button

#store original scale
var original_size := scale
#size button grows to when hovered over
var grow_size := Vector2(1.1,1.1)

#Path to level file
@export_file(".txt") var level_path: String
@export var board: Node2D

#Default icon texture
@export var normal_texture: Texture2D
# Hover (highlighted) icon texture
@export var hover_texture: Texture2D

#The level number to show on the button
@export var level_number: int = 1
#Reference to the Label node that will display the number
@onready var level_label: Label = $LevelLabel

# Called when the node enters the scene tree
func _ready() -> void:
 # Set the default texture
 if normal_texture:
  self.icon = normal_texture
 # Set the level number text
 if level_label:
  level_label.text = str(level_number)
 else:
  print("LevelLabel not found on ", name)

#Called when the node enters the scene tree for the first time.
func grow_btn(end_size: Vector2, duration: float) -> void:
 var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
 tween.tween_property(self, 'scale', end_size, duration)


func _on_mouse_entered() -> void:
 # Grow the button slightly
 grow_btn(grow_size, .1)
 # Swap to the hover texture if assigned
 if hover_texture:
  self.icon = hover_texture


func _on_mouse_exited() -> void:
 grow_btn(original_size, .1)
# Swap to the hover texture if assigned
 if hover_texture:
  self.icon = normal_texture


func _on_pressed() -> void:
 
  board._spawnBoard(level_path)
  get_parent().get_parent()._noDisplay()

	
	 
	
 	 
 
