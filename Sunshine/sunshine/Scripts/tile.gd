extends TextureButton

@onready var gameBoard := get_parent()
@onready var frozenFlowerTexture := preload("res://Textures/frozen_flower.png")
@onready var buddingFlowerTexture := preload("res://Textures/budding_flower.png")
@onready var meltedFlowerTexture := preload("res://Textures/melted_flower.png")
@onready var frozenTreeTexture := preload("res://Textures/frozen_tree.png")
@onready var meltedTreeTexture := preload("res://Textures/melted_tree.png")
@onready var frozenRiverTexture := preload("res://Textures/frozen_river.png")
@onready var meltedRiverTexture := preload("res://Textures/melted_river.png")
@onready var frozenSnowmanTexture := preload("res://Textures/frozen_snowman.png")
@onready var meltedSnowmanTexture := preload("res://Textures/melted_snowman.png")
@onready var frozenGrassTexture := preload("res://Textures/frozen_grass.png")
@onready var meltedGrassTexture := preload("res://Textures/melted_grass.png")

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
				texture_normal = buddingFlowerTexture
			else:
				tileState = TileState.MELTED
				texture_normal = meltedFlowerTexture
		TileType.TREE:
			tileState = TileState.MELTED
			texture_normal = meltedTreeTexture
		TileType.RIVER:
			tileState = TileState.MELTED
			texture_normal = meltedRiverTexture
		TileType.SNOWMAN:
			tileState = TileState.MELTED
			texture_normal = meltedSnowmanTexture
		TileType.GRASS:
			tileState = TileState.MELTED
			texture_normal = meltedGrassTexture

#sets this tile to a certain type and state
func _set_tile(tileID) -> void:
	match tileID:
		"FF":
			tileType = TileType.FLOWER
			texture_normal = frozenFlowerTexture
		"BF":
			tileType = TileType.FLOWER
			tileState = TileState.BUDDING
			texture_normal = buddingFlowerTexture
		"MF":
			tileType = TileType.FLOWER
			tileState = TileState.MELTED
			texture_normal = meltedFlowerTexture
		"FT":
			tileType = TileType.TREE
			texture_normal = frozenTreeTexture
		"MT":
			tileType = TileType.TREE
			tileState = TileState.MELTED
			texture_normal = meltedTreeTexture
		"FR":
			tileType = TileType.RIVER
			texture_normal = frozenRiverTexture
		"MR":
			tileType = TileType.RIVER
			tileState = TileState.MELTED
			texture_normal = meltedRiverTexture
		"FS":
			tileType = TileType.SNOWMAN
			texture_normal = frozenSnowmanTexture
		"MS":
			tileType = TileType.SNOWMAN
			tileState = TileState.MELTED
			texture_normal = meltedSnowmanTexture
		"FG":
			tileType = TileType.GRASS
			texture_normal = frozenGrassTexture
		"MG":
			tileType = TileType.GRASS
			tileState = TileState.MELTED
			texture_normal = meltedGrassTexture
		
