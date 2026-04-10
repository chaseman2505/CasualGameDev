extends Node2D
@onready var frozenFlowerTexture1 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower1.png")
@onready var frozenFlowerTexture2 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower2.png")
@onready var frozenFlowerTexture3 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower3.png")
@onready var frozenFlowerTexture4 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower4.png")
@onready var frozenFlowerTexture5 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower5.png")
@onready var frozenFlowerTexture6 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower6.png")
@onready var frozenFlowerTexture7 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower7.png")
@onready var frozenFlowerTexture8 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower8.png")
@onready var frozenFlowerTexture9 := preload("res://Textures/FlowerTiles/Frozen/FrozenFlower9.png")

@onready var buddingFlowerTexture1 := preload("res://Textures/FlowerTiles/Budding/BabyFlower1.png")
@onready var buddingFlowerTexture2 := preload("res://Textures/FlowerTiles/Budding/BabyFlower2.png")
@onready var buddingFlowerTexture3 := preload("res://Textures/FlowerTiles/Budding/BabyFlower3.png")
@onready var buddingFlowerTexture4 := preload("res://Textures/FlowerTiles/Budding/BabyFlower4.png")
@onready var buddingFlowerTexture5 := preload("res://Textures/FlowerTiles/Budding/BabyFlower5.png")
@onready var buddingFlowerTexture6 := preload("res://Textures/FlowerTiles/Budding/BabyFlower6.png")
@onready var buddingFlowerTexture7 := preload("res://Textures/FlowerTiles/Budding/BabyFlower7.png")
@onready var buddingFlowerTexture8 := preload("res://Textures/FlowerTiles/Budding/BabyFlower8.png")
@onready var buddingFlowerTexture9 := preload("res://Textures/FlowerTiles/Budding/BabyFlower9.png")

@onready var meltedFlowerTexture1 := preload("res://Textures/FlowerTiles/Melted/FullFlower1.png")
@onready var meltedFlowerTexture2 := preload("res://Textures/FlowerTiles/Melted/FullFlower2.png")
@onready var meltedFlowerTexture3 := preload("res://Textures/FlowerTiles/Melted/FullFlower3.png")
@onready var meltedFlowerTexture4 := preload("res://Textures/FlowerTiles/Melted/FullFlower4.png")
@onready var meltedFlowerTexture5 := preload("res://Textures/FlowerTiles/Melted/FullFlower5.png")
@onready var meltedFlowerTexture6 := preload("res://Textures/FlowerTiles/Melted/FullFlower6.png")
@onready var meltedFlowerTexture7 := preload("res://Textures/FlowerTiles/Melted/FullFlower7.png")
@onready var meltedFlowerTexture8 := preload("res://Textures/FlowerTiles/Melted/FullFlower8.png")
@onready var meltedFlowerTexture9 := preload("res://Textures/FlowerTiles/Melted/FullFlower9.png")

@onready var frozenTreeTexture1 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen1.png")
@onready var frozenTreeTexture2 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen2.png")
@onready var frozenTreeTexture3 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen3.png")
@onready var frozenTreeTexture4 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen4.png")
@onready var frozenTreeTexture5 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen5.png")
@onready var frozenTreeTexture6 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen6.png")
@onready var frozenTreeTexture7 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen7.png")
@onready var frozenTreeTexture8 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen8.png")
@onready var frozenTreeTexture9 := preload("res://Textures/TreeTiles/Frozen/TreeFrozen9.png")

@onready var meltedTreeTexture1 := preload("res://Textures/TreeTiles/Melted/TreeMelted1.png")
@onready var meltedTreeTexture2 := preload("res://Textures/TreeTiles/Melted/TreeMelted2.png")
@onready var meltedTreeTexture3 := preload("res://Textures/TreeTiles/Melted/TreeMelted3.png")
@onready var meltedTreeTexture4 := preload("res://Textures/TreeTiles/Melted/TreeMelted4.png")
@onready var meltedTreeTexture5 := preload("res://Textures/TreeTiles/Melted/TreeMelted5.png")
@onready var meltedTreeTexture6 := preload("res://Textures/TreeTiles/Melted/TreeMelted6.png")
@onready var meltedTreeTexture7 := preload("res://Textures/TreeTiles/Melted/TreeMelted7.png")
@onready var meltedTreeTexture8 := preload("res://Textures/TreeTiles/Melted/TreeMelted8.png")
@onready var meltedTreeTexture9 := preload("res://Textures/TreeTiles/Melted/TreeMelted9.png")

@onready var frozenRiverCornerTexture1 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenCorner1.png")
@onready var frozenRiverCornerTexture2 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenCorner2.png")
@onready var frozenRiverCornerTexture3 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenCorner3.png")
@onready var frozenRiverCornerTexture4 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenCorner4.png")

@onready var frozenRiverHorizontalTexture1 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenHorizontal1.png")
@onready var frozenRiverHorizontalTexture2 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenHorizontal2.png")
@onready var frozenRiverHorizontalTexture3 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenHorizontal3.png")

@onready var frozenRiverVerticalTexture1 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenVertical1.png")
@onready var frozenRiverVerticalTexture2 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenVertical2.png")
@onready var frozenRiverVerticalTexture3 := preload("res://Textures/RiverTiles/Frozen/RiverFrozenVertical3.png")

@onready var meltedRiverCornerTexture1 := preload("res://Textures/RiverTiles/Melted/RiverMeltedCorner1.png")
@onready var meltedRiverCornerTexture2 := preload("res://Textures/RiverTiles/Melted/RiverMeltedCorner2.png")
@onready var meltedRiverCornerTexture3 := preload("res://Textures/RiverTiles/Melted/RiverMeltedCorner3.png")
@onready var meltedRiverCornerTexture4 := preload("res://Textures/RiverTiles/Melted/RiverMeltedCorner4.png")

@onready var meltedRiverHorizontalTexture1 := preload("res://Textures/RiverTiles/Melted/RiverMeltedHorizontal1.png")
@onready var meltedRiverHorizontalTexture2 := preload("res://Textures/RiverTiles/Melted/RiverMeltedHorizontal2.png")
@onready var meltedRiverHorizontalTexture3 := preload("res://Textures/RiverTiles/Melted/RiverMeltedHorizontal3.png")

@onready var meltedRiverVerticalTexture1 := preload("res://Textures/RiverTiles/Melted/RiverMeltedVertical1.png")
@onready var meltedRiverVerticalTexture2 := preload("res://Textures/RiverTiles/Melted/RiverMeltedVertical2.png")
@onready var meltedRiverVerticalTexture3 := preload("res://Textures/RiverTiles/Melted/RiverMeltedVertical3.png")

@onready var frozenSnowmanTexture1 := preload("res://Textures/SnowmanTiles/Frozen/Snowman1.png")
@onready var frozenSnowmanTexture2 := preload("res://Textures/SnowmanTiles/Frozen/Snowman2.png")
@onready var frozenSnowmanTexture3 := preload("res://Textures/SnowmanTiles/Frozen/Snowman3.png")
@onready var frozenSnowmanTexture4 := preload("res://Textures/SnowmanTiles/Frozen/Snowman4.png")
@onready var frozenSnowmanTexture5 := preload("res://Textures/SnowmanTiles/Frozen/Snowman5.png")
@onready var frozenSnowmanTexture6 := preload("res://Textures/SnowmanTiles/Frozen/Snowman6.png")
@onready var frozenSnowmanTexture7 := preload("res://Textures/SnowmanTiles/Frozen/Snowman7.png")
@onready var frozenSnowmanTexture8 := preload("res://Textures/SnowmanTiles/Frozen/Snowman8.png")
@onready var frozenSnowmanTexture9 := preload("res://Textures/SnowmanTiles/Frozen/Snowman9.png")

@onready var frozenGrassTexture1 := preload("res://Textures/GrassTextures/Frozen/SnowTile1.png")
@onready var frozenGrassTexture2 := preload("res://Textures/GrassTextures/Frozen/SnowTile2.png")
@onready var frozenGrassTexture3 := preload("res://Textures/GrassTextures/Frozen/SnowTile3.png")
@onready var frozenGrassTexture4 := preload("res://Textures/GrassTextures/Frozen/SnowTile4.png")
@onready var frozenGrassTexture5 := preload("res://Textures/GrassTextures/Frozen/SnowTile5.png")
@onready var frozenGrassTexture6 := preload("res://Textures/GrassTextures/Frozen/SnowTile6.png")
@onready var frozenGrassTexture7 := preload("res://Textures/GrassTextures/Frozen/SnowTile7.png")
@onready var frozenGrassTexture8 := preload("res://Textures/GrassTextures/Frozen/SnowTile8.png")
@onready var frozenGrassTexture9 := preload("res://Textures/GrassTextures/Frozen/SnowTile9.png")
@onready var meltedGrassTexture1 := preload("res://Textures/GrassTextures/Melted/GrassTile1.png")
@onready var meltedGrassTexture2 := preload("res://Textures/GrassTextures/Melted/GrassTile2.png")
@onready var meltedGrassTexture3 := preload("res://Textures/GrassTextures/Melted/GrassTile3.png")
@onready var meltedGrassTexture4 := preload("res://Textures/GrassTextures/Melted/GrassTile4.png")
@onready var meltedGrassTexture5 := preload("res://Textures/GrassTextures/Melted/GrassTile5.png")
@onready var meltedGrassTexture6 := preload("res://Textures/GrassTextures/Melted/GrassTile6.png")
@onready var meltedGrassTexture7 := preload("res://Textures/GrassTextures/Melted/GrassTile7.png")
@onready var meltedGrassTexture8 := preload("res://Textures/GrassTextures/Melted/GrassTile8.png")
@onready var meltedGrassTexture9 := preload("res://Textures/GrassTextures/Melted/GrassTile9.png")
@onready var tileGrid := [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)", $"Tile(0,3)", $"Tile(0,4)"], #this line is column 0 not row 0
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)", $"Tile(1,3)", $"Tile(1,4)"], #this line is column 1 not row 1
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)", $"Tile(2,3)", $"Tile(2,4)"],  #this line is column 2 not row 2
	[$"Tile(3,0)", $"Tile(3,1)", $"Tile(3,2)", $"Tile(3,3)", $"Tile(3,4)"],  #this line is column 3 not row 3
	[$"Tile(4,0)", $"Tile(4,1)", $"Tile(4,2)", $"Tile(4,3)", $"Tile(4,4)"],  #this line is column 4 not row 4
]

#the amount the y of a tile increases when hovered
const hoverYIncrease := 10

#the amount the y of a tile decreases when held down
const heldYDecrease := 5

#how many moves were used so far
var movesUsed = 0

#timer used to track when updates occur
var timer := 0.0

#how many seconds between each round of tile updates
var updateSpeed := 0.3

#if any tiles are in queue to be updated
var updatesOccuring = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(tileGrid.size()):
		for y in range(tileGrid[x].size()):
			tileGrid[x][y].tileGridPosition = Vector2(x, y)
	_read_file("res://Levels/level3.txt")
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if updatesOccuring:
		timer -= delta
		if timer <= 0:
			var anyTilesLeftToUpdate := false
			for x in range(tileGrid.size()):
				for y in range(tileGrid[x].size()):
					if tileGrid[x][y].queuePosition == 0:
						tileGrid[x][y]._melt()
					elif tileGrid[x][y].queuePosition > 0:
						anyTilesLeftToUpdate = true
						tileGrid[x][y].queuePosition -= 1
			if anyTilesLeftToUpdate == false:
				updatesOccuring = false
				timer = 0
			else:
				timer += updateSpeed


func _trigger_interaction(tile) -> void:
	movesUsed += 1
	print(movesUsed)
	_update_queuePosition(tile, 0)
	updatesOccuring = true
	#for a in range(tileGrid.size()):
	#	for b in range(tileGrid[a].size()):
	#		print(tileGrid[a][b].name + ": " + str(tileGrid[a][b].queuePosition))
	
	
	
func _update_queuePosition(tile, iterationNumber) -> void:
	if tile.queuePosition != -1 and tile.queuePosition <= iterationNumber:
		return
	if (tile.tileState == tile.TileState.FROZEN or tile.tileState == tile.TileState.BUDDING) and (tile.queuePosition == -1 or tile.queuePosition > iterationNumber):
		tile.queuePosition = iterationNumber
	var x = tile.tileGridPosition.x
	var y = tile.tileGridPosition.y
	match tile.tileType:
		tile.TileType.TREE:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x - 1, y - 1), Vector2(x, y - 1), Vector2(x + 1, y - 1), Vector2(x - 1, y), 
				Vector2(x + 1, y), Vector2(x - 1, y + 1), Vector2(x, y + 1), Vector2(x + 1, y + 1)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and (tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN or tileGrid[position.x][position.y].tileState == tile.TileState.BUDDING) and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
						
		tile.TileType.RIVER:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.RIVER and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
			
		tile.TileType.FLOWER:
			if tile.tileState == tile.TileState.BUDDING:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.FLOWER and (tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN or tileGrid[position.x][position.y].tileState == tile.TileState.BUDDING) and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						tileGrid[position.x][position.y].tileState = tileGrid[position.x][position.y].TileState.BUDDING
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
								
		tile.TileType.SNOWMAN:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1),
				Vector2(x, y - 2), Vector2(x - 2, y), Vector2(x + 2, y), Vector2(x, y + 2),
				Vector2(x, y - 3), Vector2(x - 3, y), Vector2(x + 3, y), Vector2(x, y + 3),
				Vector2(x, y - 4), Vector2(x - 4, y), Vector2(x + 4, y), Vector2(x, y + 4)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and (tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN or tileGrid[position.x][position.y].tileState == tile.TileState.BUDDING):
						if position.x == x - 1 or position.x ==  x + 1 or position.y == y - 1 or position.y == y + 1:
							_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
						elif position.x == x - 2 or position.x ==  x + 2 or position.y == y - 2 or position.y == y + 2:
							_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 2)
						elif position.x == x - 3 or position.x ==  x + 3 or position.y == y - 3 or position.y == y + 3:
							_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 3)
						elif position.x == x - 4 or position.x ==  x + 4 or position.y == y - 4 or position.y == y + 4:
							_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 4)

#returns true if a position is in the bounds of the tileGrid
func _position_in_bounds(x, y) -> bool:
	if x >= 0 and x < tileGrid.size() and y >= 0 and y < tileGrid[x].size():
		return true
	else:
		return false

#reads level file and sets board state based on the level file	
func _read_file(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file != null:
		var lines = file.get_as_text().split("\n")
		#how many top lines to skip when first reading the file
		const skipLines := 3
		for currentLineNumber in range(skipLines, lines.size() - 1):
			var currentLine = lines[currentLineNumber].split(",")
			for currentSectionNumber in range(currentLine.size()):
				#the y is 1 less than the currentLineNumber because the first line is skipped
				#line 1 is at y = 0
				var x = currentSectionNumber
				var y = currentLineNumber - skipLines
				if _position_in_bounds(x, y):
					tileGrid[x][y]._set_tile(currentLine[currentSectionNumber])
				else:
					print("Error reading file: index out of range")
		file.close()
	#if the file fails to load
	else:
		rotation = 45
