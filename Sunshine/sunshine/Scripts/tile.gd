extends TextureButton

@onready var gameBoard := get_parent()
enum TileType {
	FLOWER,
	TREE
}
enum TileState {
	FROZEN,
	MELTED
}

var tileType := TileType.TREE
var tileState := TileState.FROZEN
var tileGridPosition := Vector2(0,0)
#signal tile_pressed(sender)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed():
	#emit_signal("tile_pressed", self)
	gameBoard._tile_pressed(tileGridPosition)
	
func _update_tile():
	print(self.name)
	tileState = TileState.MELTED
	self.modulate.a = 0.5
