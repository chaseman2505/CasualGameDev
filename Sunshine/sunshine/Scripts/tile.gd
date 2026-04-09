extends TextureButton

@onready var gameBoard := get_parent()
@onready var outline := $Outline

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

var frozenTexture
var meltedTexture
var buddingTexture

#Outline Fade In Variables
var outlineAlpha := 0.0
var outlineTargetAlpha := 0.0
var outlineFadeSpeed := 12

#what position this tile is in the update queue
#-1 means it is not in the queue
var queuePosition := -1

#amount of bounce applied when a tile melts
const meltBounce := 4
var isBouncing := false

#the starting y position of this tile
var startingY

#what y position the tile is approaching
var targetY

#how fast the tile lerps to the targetY
var lerpSpeed := 10

#how fastthe tile lerps to the targetY if targetY equals the startingY
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
	
	#set outline off by default
	outline.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed := lerpSpeed
	
	# If returning to resting position, use slower return speed
	if targetY == startingY:
		speed = returnLerpSpeed
	
	position.y = lerp(position.y, targetY, delta * speed)
	
	# If we reached the bounce peak, return to resting position
	if abs(position.y - targetY) < 0.5 and targetY != startingY and (!is_hovered() or isBouncing):
		targetY = startingY
		isBouncing = false
		
	#Lerp outline's alpha
	outlineAlpha = lerp(outlineAlpha, outlineTargetAlpha, delta * outlineFadeSpeed)
	outline.modulate.a = outlineAlpha

#when this tile is clicked
func _on_pressed() -> void:
	targetY = startingY + gameBoard.heldYDecrease
	modulate = pressedDarkness
	
#when this tile is released
func _on_released() -> void:
	gameBoard._trigger_interaction(self)
	targetY = startingY
	modulate = normalColor
	outlineTargetAlpha = 0.0

#when this tile is hovered over
func _on_mouse_entered() -> void:
	isHovered = true
	targetY = startingY - gameBoard.hoverYIncrease
	outlineTargetAlpha = 1.0

#when this tile is not hovered over
func _on_mouse_exited() -> void:
	isHovered = false
	targetY = startingY
	outlineTargetAlpha = 0.0


#when this tile is melted
func _melt() -> void:
	queuePosition = -1
	
	# Bounce upward when melted
	targetY = startingY - meltBounce
	isBouncing = true
	
	match tileType:
		TileType.TREE:
			tileState = TileState.MELTED
			texture_normal = meltedTexture
		TileType.RIVER:
			tileState = TileState.MELTED
			texture_normal = gameBoard.meltedRiverTexture
		TileType.SNOWMAN:
			tileState = TileState.MELTED
			texture_normal = meltedTexture
		TileType.GRASS:
			tileState = TileState.MELTED
			texture_normal = meltedTexture
					
		TileType.FLOWER:
			if tileState == TileState.FROZEN:
				tileState = TileState.BUDDING
				texture_normal = buddingTexture
			elif tileState == TileState.BUDDING:
				tileState = TileState.MELTED
				texture_normal = meltedTexture

#sets this tile to a certain type and state
func _set_tile(tileID: String) -> void:
	
	var tileStateID := tileID.substr(0, 1)
	var tileTypeID := tileID.substr(1, 1)
	var tileVariantID := tileID.substr(2, 1)
	match tileTypeID:
		#flower
		"F":
			tileType = TileType.FLOWER
			match tileVariantID:
				"1":
					frozenTexture = gameBoard.frozenFlowerTexture1
					meltedTexture = gameBoard.meltedFlowerTexture1
					buddingTexture = gameBoard.buddingFlowerTexture1
				"2":
					frozenTexture = gameBoard.frozenFlowerTexture2
					meltedTexture = gameBoard.meltedFlowerTexture2
					buddingTexture = gameBoard.buddingFlowerTexture2
				"3":
					frozenTexture = gameBoard.frozenFlowerTexture3
					meltedTexture = gameBoard.meltedFlowerTexture3
					buddingTexture = gameBoard.buddingFlowerTexture3
				"4":
					frozenTexture = gameBoard.frozenFlowerTexture4
					meltedTexture = gameBoard.meltedFlowerTexture4
					buddingTexture = gameBoard.buddingFlowerTexture4
				"5":
					frozenTexture = gameBoard.frozenFlowerTexture5
					meltedTexture = gameBoard.meltedFlowerTexture5
					buddingTexture = gameBoard.buddingFlowerTexture5
				"6":
					frozenTexture = gameBoard.frozenFlowerTexture6
					meltedTexture = gameBoard.meltedFlowerTexture6
					buddingTexture = gameBoard.buddingFlowerTexture6
				"7":
					frozenTexture = gameBoard.frozenFlowerTexture7
					meltedTexture = gameBoard.meltedFlowerTexture7
					buddingTexture = gameBoard.buddingFlowerTexture7
				"8":
					frozenTexture = gameBoard.frozenFlowerTexture8
					meltedTexture = gameBoard.meltedFlowerTexture8
					buddingTexture = gameBoard.buddingFlowerTexture8
				"9":
					frozenTexture = gameBoard.frozenFlowerTexture9
					meltedTexture = gameBoard.meltedFlowerTexture9
					buddingTexture = gameBoard.buddingFlowerTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		#tree
		"T":
			tileType = TileType.TREE
			match tileVariantID:
				"1":
					frozenTexture = gameBoard.frozenTreeTexture1
					meltedTexture = gameBoard.meltedTreeTexture1
				"2":
					frozenTexture = gameBoard.frozenTreeTexture2
					meltedTexture = gameBoard.meltedTreeTexture2
				"3":
					frozenTexture = gameBoard.frozenTreeTexture3
					meltedTexture = gameBoard.meltedTreeTexture3
				"4":
					frozenTexture = gameBoard.frozenTreeTexture4
					meltedTexture = gameBoard.meltedTreeTexture4
				"5":
					frozenTexture = gameBoard.frozenTreeTexture5
					meltedTexture = gameBoard.meltedTreeTexture5
				"6":
					frozenTexture = gameBoard.frozenTreeTexture6
					meltedTexture = gameBoard.meltedTreeTexture6
				"7":
					frozenTexture = gameBoard.frozenTreeTexture7
					meltedTexture = gameBoard.meltedTreeTexture7
				"8":
					frozenTexture = gameBoard.frozenTreeTexture8
					meltedTexture = gameBoard.meltedTreeTexture8
				"9":
					frozenTexture = gameBoard.frozenTreeTexture9
					meltedTexture = gameBoard.meltedTreeTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		#river
		"R":
			tileType = TileType.RIVER
			match tileVariantID:
				"1":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"2":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"3":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"4":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"5":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"6":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"7":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"8":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				"9":
					frozenTexture = gameBoard.frozenRiverTexture
					meltedTexture = gameBoard.meltedRiverTexture
				_:
					print("Unrecognized tile ID: " + tileID)
			
		#snowman
		"S":
			tileType = TileType.SNOWMAN
			match tileVariantID:
				"1":
					frozenTexture = gameBoard.frozenSnowmanTexture1
					meltedTexture = gameBoard.meltedGrassTexture1
				"2":
					frozenTexture = gameBoard.frozenSnowmanTexture2
					meltedTexture = gameBoard.meltedGrassTexture2
				"3":
					frozenTexture = gameBoard.frozenSnowmanTexture3
					meltedTexture = gameBoard.meltedGrassTexture3
				"4":
					frozenTexture = gameBoard.frozenSnowmanTexture4
					meltedTexture = gameBoard.meltedGrassTexture4
				"5":
					frozenTexture = gameBoard.frozenSnowmanTexture5
					meltedTexture = gameBoard.meltedGrassTexture5
				"6":
					frozenTexture = gameBoard.frozenSnowmanTexture6
					meltedTexture = gameBoard.meltedGrassTexture6
				"7":
					frozenTexture = gameBoard.frozenSnowmanTexture7
					meltedTexture = gameBoard.meltedGrassTexture7
				"8":
					frozenTexture = gameBoard.frozenSnowmanTexture8
					meltedTexture = gameBoard.meltedGrassTexture8
				"9":
					frozenTexture = gameBoard.frozenSnowmanTexture9
					meltedTexture = gameBoard.meltedGrassTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
			
		#grass
		"G":
			tileType = TileType.GRASS
			match tileVariantID:
				"1":
					frozenTexture = gameBoard.frozenGrassTexture1
					meltedTexture = gameBoard.meltedGrassTexture1
				"2":
					frozenTexture = gameBoard.frozenGrassTexture2
					meltedTexture = gameBoard.meltedGrassTexture2
				"3":
					frozenTexture = gameBoard.frozenGrassTexture3
					meltedTexture = gameBoard.meltedGrassTexture3
				"4":
					frozenTexture = gameBoard.frozenGrassTexture4
					meltedTexture = gameBoard.meltedGrassTexture4
				"5":
					frozenTexture = gameBoard.frozenGrassTexture5
					meltedTexture = gameBoard.meltedGrassTexture5
				"6":
					frozenTexture = gameBoard.frozenGrassTexture6
					meltedTexture = gameBoard.meltedGrassTexture6
				"7":
					frozenTexture = gameBoard.frozenGrassTexture7
					meltedTexture = gameBoard.meltedGrassTexture7
				"8":
					frozenTexture = gameBoard.frozenGrassTexture8
					meltedTexture = gameBoard.meltedGrassTexture8
				"9":
					frozenTexture = gameBoard.frozenGrassTexture9
					meltedTexture = gameBoard.meltedGrassTexture9
				_:
					print("Unrecognized tile ID: " + tileID)
		_:
			print("Unrecognized tile ID: " + tileID)
	match tileStateID:
		#frozen
		"F":
			tileState = TileState.FROZEN
			texture_normal = frozenTexture
		#melted
		"M":
			tileState = TileState.MELTED
			texture_normal = meltedTexture
		#budding
		"B":
			tileState = TileState.BUDDING
			texture_normal = buddingTexture
		_:
			print("Unrecognized tile ID: " + tileID)
