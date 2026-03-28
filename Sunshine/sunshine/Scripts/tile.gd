extends TextureButton

@onready var gameBoard = get_parent()
enum TileState {
	FROZEN,
	MELTED
}

var tileState = TileState.FROZEN
#signal tile_pressed(sender)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed():
	#emit_signal("tile_pressed", self)
	gameBoard._tile_pressed(self)
