extends Button

#store button's original scale
var original_size := scale
#size that button will grow to when hovered over
var grow_size := Vector2(.4,.4)

# Default (normal) button texture
@export var normal_texture: Texture2D

# Highlighted texture when hovering
@export var hover_texture: Texture2D

#Smoothly scale button size over time
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
