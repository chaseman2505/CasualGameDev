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
	queuePosition = -1
	match tileType:
		TileType.FLOWER:
			if tileState == TileState.FROZEN:
				tileState = TileState.BUDDING
				texture_normal = gameBoard.buddingFlowerTexture
			else:
				tileState = TileState.MELTED
				texture_normal = gameBoard.meltedFlowerTexture
		TileType.TREE:
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedTreeTexture
		TileType.RIVER:
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedRiverTexture
		TileType.SNOWMAN:
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedSnowmanTexture
		TileType.GRASS:
			tileState = TileState.MELTED
			match texture_normal:
				gameBoard.frozenGrassTexture1:
					texture_normal = gameBoard.meltedGrassTexture1
				gameBoard.frozenGrassTexture2:
					texture_normal = gameBoard.meltedGrassTexture2
				gameBoard.frozenGrassTexture3:
					texture_normal = gameBoard.meltedGrassTexture3
				gameBoard.frozenGrassTexture4:
					texture_normal = gameBoard.meltedGrassTexture4
				gameBoard.frozenGrassTexture5:
					texture_normal = gameBoard.meltedGrassTexture5
				gameBoard.frozenGrassTexture6:
					texture_normal = gameBoard.meltedGrassTexture6
				gameBoard.frozenGrassTexture7:
					texture_normal = gameBoard.meltedGrassTexture7
				gameBoard.frozenGrassTexture8:
					texture_normal = gameBoard.meltedGrassTexture8
				gameBoard.frozenGrassTexture9:
					texture_normal = gameBoard.meltedGrassTexture9

#sets this tile to a certain type and state
func _set_tile(tileID: String) -> void:
	var tileID1 := tileID.substr(0, 2)
	var tileID2 := tileID.substr(2, 2)
	match tileID1:
		"FF1":
			tileType = TileType.FLOWER
			texture_normal = gameBoard.frozenFlowerTexture
		"BF":
			tileType = TileType.FLOWER
			tileState = TileState.BUDDING
			texture_normal = gameBoard.buddingFlowerTexture
		"MF":
			tileType = TileType.FLOWER
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedFlowerTexture
		"FT":
			tileType = TileType.TREE
			texture_normal = gameBoard.frozenTreeTexture
		"MT":
			tileType = TileType.TREE
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedTreeTexture
		"FR":
			tileType = TileType.RIVER
			texture_normal = gameBoard.frozenRiverTexture
		"MR":
			tileType = TileType.RIVER
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedRiverTexture
		"FS":
			tileType = TileType.SNOWMAN
			texture_normal = gameBoard.frozenSnowmanTexture
		"MS":
			tileType = TileType.SNOWMAN
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedSnowmanTexture
		"FG":
			tileType = TileType.GRASS
			match tileID2:
				"1":
					texture_normal = gameBoard.frozenGrassTexture1
				"2":
					texture_normal = gameBoard.frozenGrassTexture2
				"3":
					texture_normal = gameBoard.frozenGrassTexture3
				"4":
					texture_normal = gameBoard.frozenGrassTexture4
				"5":
					texture_normal = gameBoard.frozenGrassTexture5
				"6":
					texture_normal = gameBoard.frozenGrassTexture6
				"7":
					texture_normal = gameBoard.frozenGrassTexture7
				"8":
					texture_normal = gameBoard.frozenGrassTexture8
				"9":
					texture_normal = gameBoard.frozenGrassTexture9
		"MG":
			tileType = TileType.GRASS
			tileState = TileState.MELTED
			match tileID2:
				"1":
					texture_normal = gameBoard.meltedGrassTexture1
				"2":
					texture_normal = gameBoard.meltedGrassTexture2
				"3":
					texture_normal = gameBoard.meltedGrassTexture3
				"4":
					texture_normal = gameBoard.meltedGrassTexture4
				"5":
					texture_normal = gameBoard.meltedGrassTexture5
				"6":
					texture_normal = gameBoard.meltedGrassTexture6
				"7":
					texture_normal = gameBoard.meltedGrassTexture7
				"8":
					texture_normal = gameBoard.meltedGrassTexture8
				"9":
					texture_normal = gameBoard.meltedGrassTexture9
		
