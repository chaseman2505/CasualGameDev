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

#amount of bounce applied when a tile melts
const meltBounce := 4

#the starting y position of this tile
var startingY
var targetY
var lerpSpeed := 10
var returnLerpSpeed := 6
var isHovered := false

#Adding a darkness multiplier to simulate shadows when the tile is pressed down
const pressedDarkness := Color(0.809, 0.809, 0.809, 1.0)
const normalColor := Color(1, 1, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connects signals to functions
	self.button_down.connect(_on_pressed)
	self.button_up.connect(_on_released)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	startingY = position.y
	targetY = startingY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed := lerpSpeed
	
	# If returning to resting position, use slower return speed
	if targetY == startingY:
		speed = returnLerpSpeed
	
	position.y = lerp(position.y, targetY, delta * speed)
	
	# If we reached the bounce peak, return to resting position
	# Only auto-return for melt bounce
	if abs(position.y - targetY) < 0.5 and targetY != startingY and !isHovered:
		targetY = startingY

#when this tile is clicked
func _on_pressed() -> void:
	targetY = startingY + gameBoard.heldYDecrease
	modulate = pressedDarkness
	
#when this tile is released
func _on_released() -> void:
	gameBoard._trigger_interaction(self)
	targetY = startingY
	modulate = normalColor

#when this tile is hovered over
func _on_mouse_entered() -> void:
	isHovered = true
	targetY = startingY - gameBoard.hoverYIncrease

#when this tile is not hovered over
func _on_mouse_exited() -> void:
	isHovered = false
	targetY = startingY


#when this tile is melted
func _melt() -> void:
	queuePosition = -1
	
	# Bounce upward when melted
	targetY = startingY - meltBounce
	match tileType:
		TileType.TREE:
			tileState = TileState.MELTED
			match texture_normal:
				gameBoard.frozenTreeTexture1:
					texture_normal = gameBoard.meltedTreeTexture1
				gameBoard.frozenTreeTexture2:
					texture_normal = gameBoard.meltedTreeTexture2
				gameBoard.frozenTreeTexture3:
					texture_normal = gameBoard.meltedTreeTexture3
				gameBoard.frozenTreeTexture4:
					texture_normal = gameBoard.meltedTreeTexture4
				gameBoard.frozenTreeTexture5:
					texture_normal = gameBoard.meltedTreeTexture5
				gameBoard.frozenTreeTexture6:
					texture_normal = gameBoard.meltedTreeTexture6
				gameBoard.frozenTreeTexture7:
					texture_normal = gameBoard.meltedTreeTexture7
				gameBoard.frozenTreeTexture8:
					texture_normal = gameBoard.meltedTreeTexture8
				gameBoard.frozenTreeTexture9:
					texture_normal = gameBoard.meltedTreeTexture9
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
					
		TileType.FLOWER:
			if tileState == TileState.FROZEN:
				tileState = TileState.BUDDING
				match texture_normal:
					gameBoard.frozenFlowerTexture1:
						texture_normal = gameBoard.buddingFlowerTexture1
					gameBoard.frozenFlowerTexture2:
						texture_normal = gameBoard.buddingFlowerTexture2
					gameBoard.frozenFlowerTexture3:
						texture_normal = gameBoard.buddingFlowerTexture3
					gameBoard.frozenFlowerTexture4:
						texture_normal = gameBoard.buddingFlowerTexture4
					gameBoard.frozenFlowerTexture5:
						texture_normal = gameBoard.buddingFlowerTexture5
					gameBoard.frozenFlowerTexture6:
						texture_normal = gameBoard.buddingFlowerTexture6
					gameBoard.frozenFlowerTexture7:
						texture_normal = gameBoard.buddingFlowerTexture7
					gameBoard.frozenFlowerTexture8:
						texture_normal = gameBoard.buddingFlowerTexture8
					gameBoard.frozenFlowerTexture9:
						texture_normal = gameBoard.buddingFlowerTexture9
			elif tileState == TileState.BUDDING:
				tileState = TileState.MELTED
				match texture_normal:
					gameBoard.buddingFlowerTexture1:
						texture_normal = gameBoard.meltedFlowerTexture1
					gameBoard.buddingFlowerTexture2:
						texture_normal = gameBoard.meltedFlowerTexture2
					gameBoard.buddingFlowerTexture3:
						texture_normal = gameBoard.meltedFlowerTexture3
					gameBoard.buddingFlowerTexture4:
						texture_normal = gameBoard.meltedFlowerTexture4
					gameBoard.buddingFlowerTexture5:
						texture_normal = gameBoard.meltedFlowerTexture5
					gameBoard.buddingFlowerTexture6:
						texture_normal = gameBoard.meltedFlowerTexture6
					gameBoard.buddingFlowerTexture7:
						texture_normal = gameBoard.meltedFlowerTexture7
					gameBoard.buddingFlowerTexture8:
						texture_normal = gameBoard.meltedFlowerTexture8
					gameBoard.buddingFlowerTexture9:
						texture_normal = gameBoard.meltedFlowerTexture9
					gameBoard.frozenFlowerTexture1:
						texture_normal = gameBoard.meltedFlowerTexture1
					gameBoard.frozenFlowerTexture2:
						texture_normal = gameBoard.meltedFlowerTexture2
					gameBoard.frozenFlowerTexture3:
						texture_normal = gameBoard.meltedFlowerTexture3
					gameBoard.frozenFlowerTexture4:
						texture_normal = gameBoard.meltedFlowerTexture4
					gameBoard.frozenFlowerTexture5:
						texture_normal = gameBoard.meltedFlowerTexture5
					gameBoard.frozenFlowerTexture6:
						texture_normal = gameBoard.meltedFlowerTexture6
					gameBoard.frozenFlowerTexture7:
						texture_normal = gameBoard.meltedFlowerTexture7
					gameBoard.frozenFlowerTexture8:
						texture_normal = gameBoard.meltedFlowerTexture8
					gameBoard.frozenFlowerTexture9:
						texture_normal = gameBoard.meltedFlowerTexture9

#sets this tile to a certain type and state
func _set_tile(tileID: String) -> void:
	
	#First and second part of tile ID
	var tileID1 := tileID.substr(0, 2)
	var tileID2 := tileID.substr(2, 2)
	match tileID1:
		"FF":
			tileType = TileType.FLOWER
			match tileID2:
				"1":
					texture_normal = gameBoard.frozenFlowerTexture1
				"2":
					texture_normal = gameBoard.frozenFlowerTexture2
				"3":
					texture_normal = gameBoard.frozenFlowerTexture3
				"4":
					texture_normal = gameBoard.frozenFlowerTexture4
				"5":
					texture_normal = gameBoard.frozenFlowerTexture5
				"6":
					texture_normal = gameBoard.frozenFlowerTexture6
				"7":
					texture_normal = gameBoard.frozenFlowerTexture7
				"8":
					texture_normal = gameBoard.frozenFlowerTexture8
				"9":
					texture_normal = gameBoard.frozenFlowerTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		"BF":
			tileType = TileType.FLOWER
			tileState = TileState.BUDDING
			match tileID2:
				"1":
					texture_normal = gameBoard.buddingFlowerTexture1
				"2":
					texture_normal = gameBoard.buddingFlowerTexture2
				"3":
					texture_normal = gameBoard.buddingFlowerTexture3
				"4":
					texture_normal = gameBoard.buddingFlowerTexture4
				"5":
					texture_normal = gameBoard.buddingFlowerTexture5
				"6":
					texture_normal = gameBoard.buddingFlowerTexture6
				"7":
					texture_normal = gameBoard.buddingFlowerTexture7
				"8":
					texture_normal = gameBoard.buddingFlowerTexture8
				"9":
					texture_normal = gameBoard.buddingFlowerTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		"MF":
			tileType = TileType.FLOWER
			tileState = TileState.MELTED
			match tileID2:
				"1":
					texture_normal = gameBoard.meltedFlowerTexture1
				"2":
					texture_normal = gameBoard.meltedFlowerTexture2
				"3":
					texture_normal = gameBoard.meltedFlowerTexture3
				"4":
					texture_normal = gameBoard.meltedFlowerTexture4
				"5":
					texture_normal = gameBoard.meltedFlowerTexture5
				"6":
					texture_normal = gameBoard.meltedFlowerTexture6
				"7":
					texture_normal = gameBoard.meltedFlowerTexture7
				"8":
					texture_normal = gameBoard.meltedFlowerTexture8
				"9":
					texture_normal = gameBoard.meltedFlowerTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		"FT":
			tileType = TileType.TREE
			match tileID2:
				"1":
					texture_normal = gameBoard.frozenTreeTexture1
				"2":
					texture_normal = gameBoard.frozenTreeTexture2
				"3":
					texture_normal = gameBoard.frozenTreeTexture3
				"4":
					texture_normal = gameBoard.frozenTreeTexture4
				"5":
					texture_normal = gameBoard.frozenTreeTexture5
				"6":
					texture_normal = gameBoard.frozenTreeTexture6
				"7":
					texture_normal = gameBoard.frozenTreeTexture7
				"8":
					texture_normal = gameBoard.frozenTreeTexture8
				"9":
					texture_normal = gameBoard.frozenTreeTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		"MT":
			tileType = TileType.TREE
			tileState = TileState.MELTED
			match tileID2:
				"1":
					texture_normal = gameBoard.meltedTreeTexture1
				"2":
					texture_normal = gameBoard.meltedTreeTexture2
				"3":
					texture_normal = gameBoard.meltedTreeTexture3
				"4":
					texture_normal = gameBoard.meltedTreeTexture4
				"5":
					texture_normal = gameBoard.meltedTreeTexture5
				"6":
					texture_normal = gameBoard.meltedTreeTexture6
				"7":
					texture_normal = gameBoard.meltedTreeTexture7
				"8":
					texture_normal = gameBoard.meltedTreeTexture8
				"9":
					texture_normal = gameBoard.meltedTreeTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
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
				_:
					print("Unrecognized tile ID: " + tileID)
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
				_:
					print("Unrecognized tile ID: " + tileID)
		_:
			print("Unrecognized tile ID: " + tileID)
		
