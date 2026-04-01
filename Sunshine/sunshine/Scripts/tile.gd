extends TextureButton

@onready var gameBoard := get_parent()
enum TileType {
	FLOWER,
	TREE,
	RIVER,
	SNOWMAN,
	GRASS
}
enum TileState {
	FROZEN,
	MELTED,
	BUDDING #only for flower tiles
}

var tileType := TileType.GRASS
var tileState := TileState.FROZEN
var tileGridPosition := Vector2(0,0)

#what position this tile is in the update queue
#-1 means it is not in the queue
var queuePosition := -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#when this tile is clicked
func _on_pressed() -> void:
	gameBoard._trigger_interaction(self)

#when this tile is melted
func _melt() -> void:
	tileState = TileState.MELTED
	modulate.a = 0.5
	queuePosition = -1

#sets this tile to a certain type and state
func _set_tile(tileID) -> void:
	match tileID:
		"frozen_flower":
			tileType = TileType.FLOWER
		"budding_flower":
			tileType = TileType.FLOWER
			tileState = TileState.BUDDING
		"melted_flower":
			tileType = TileType.FLOWER
			tileState = TileState.MELTED
		"frozen_tree":
			tileType = TileType.TREE
		"melted_tree":
			tileType = TileType.TREE
			tileState = TileState.MELTED
		"frozen_river":
			tileType = TileType.RIVER
		"melted_river":
			tileType = TileType.RIVER
			tileState = TileState.MELTED
		"frozen_snowman":
			tileType = TileType.SNOWMAN
		"melted_snowman":
			tileType = TileType.SNOWMAN
			tileState = TileState.MELTED
		"frozen_grass":
			tileType = TileType.GRASS
		"melted_grass":
			tileType = TileType.GRASS
			tileState = TileState.MELTED
		
