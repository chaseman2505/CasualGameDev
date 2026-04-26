extends ColorRect



@onready var label = $UILabel
@onready var board = get_node("/root/Game/GameBoard")
@onready var Next = $Next
@onready var Retry = $Retry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	board.game_finished.connect(_on_game_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_finished(is_won: bool) -> void:
	self.modulate.a = 0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
	
	if is_won:
		label.text = "You Win!"
		Next.visible = true
		Retry.visible = false
	else:
		label.text = "You Lose!"
		Next.visible = false
		Retry.visible = true


func _on_next_pressed() -> void:
	hide()
