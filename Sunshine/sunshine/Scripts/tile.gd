extends TextureButton

@onready var gameBoard := get_parent()
enum TileType {
	FLOWER,
	TREE,
	RIVER
}
enum TileState {
	FROZEN,
	MELTED
}

var tileType := TileType.RIVER
var tileState := TileState.FROZEN
var tileGridPosition := Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	gameBoard._update_tile(self)
