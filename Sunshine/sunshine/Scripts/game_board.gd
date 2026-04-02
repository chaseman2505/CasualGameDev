extends Node2D

@onready var tileGrid := [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)", $"Tile(0,3)", $"Tile(0,4)"], #this line is column 0 not row 0
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)", $"Tile(1,3)", $"Tile(1,4)"], #this line is column 1 not row 1
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)", $"Tile(2,3)", $"Tile(2,4)"],  #this line is column 2 not row 2
	[$"Tile(3,0)", $"Tile(3,1)", $"Tile(3,2)", $"Tile(3,3)", $"Tile(3,4)"],  #this line is column 3 not row 3
	[$"Tile(4,0)", $"Tile(4,1)", $"Tile(4,2)", $"Tile(4,3)", $"Tile(4,4)"],  #this line is column 4 not row 4
]
var timer := 0.0

#how many seconds between each round of tile updates
var updateSpeed := 0.5

#if any tiles are in queue to be updated
var updatesOccuring = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(tileGrid.size()):
		for y in range(tileGrid[x].size()):
			tileGrid[x][y].tileGridPosition = Vector2(x, y)
	_read_file("res://Levels/level1.txt")
			


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
	_update_queuePosition(tile, 0)
	#for a in range(tileGrid.size()):
	#	for b in range(tileGrid[a].size()):
	#		print(tileGrid[a][b].name + ": " + str(tileGrid[a][b].queuePosition))
	updatesOccuring = true
	
	
	
func _update_queuePosition(tile, iterationNumber) -> void:
	if tile.tileState == tile.TileState.FROZEN and (tile.queuePosition == -1 or tile.queuePosition > iterationNumber):
		tile.queuePosition = iterationNumber
	var x = tile.tileGridPosition.x
	var y = tile.tileGridPosition.y
	match tile.tileType:
		tile.TileType.TREE:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x - 1, y - 1), Vector2(x, y - 1), Vector2(x + 1, y - 1), Vector2(x - 1, y), 
				Vector2(x + 1, y), Vector2(x - 1, y + 1), Vector2(x, y + 1), Vector2(x + 1, y + 1)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
						
		tile.TileType.RIVER:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.RIVER and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
		
		#WIP	
		tile.TileType.FLOWER:
			if tile.tileState == tile.TileState.FROZEN:
				tile.tileState = tile.TileState.BUDDING
			else:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1)]
				for position in positionsToCheck:
					if tile.tileState == tile.TileState.BUDDING and _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.FLOWER and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
						_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
		
		#WIP		
		tile.TileType.SNOWMAN:
			if tile.tileState == tile.TileState.FROZEN:
				var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1),
				Vector2(x, y - 2), Vector2(x - 2, y), Vector2(x + 2, y), Vector2(x, y + 2),
				Vector2(x, y - 3), Vector2(x - 3, y), Vector2(x + 3, y), Vector2(x, y + 3),
				Vector2(x, y - 4), Vector2(x - 4, y), Vector2(x + 4, y), Vector2(x, y + 4)]
				for position in positionsToCheck:
					if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN:
						if position.x == x - 1 or position.x ==  x + 1 or position.y == y - 1 or position.y == y + 1:
							tileGrid[position.x][position.y].queuePosition = 1
						elif position.x == x - 2 or position.x ==  x + 2 or position.y == y - 2 or position.y == y + 2:
							tileGrid[position.x][position.y].queuePosition = 2
						elif position.x == x - 3 or position.x ==  x + 3 or position.y == y - 3 or position.y == y + 3:
							tileGrid[position.x][position.y].queuePosition = 3
						elif position.x == x - 4 or position.x ==  x + 4 or position.y == y - 4 or position.y == y + 4:
							tileGrid[position.x][position.y].queuePosition = 4

#returns true if a position is in the bounds of the tileGrid
func _position_in_bounds(x, y) -> bool:
	if x >= 0 and x < tileGrid.size() and y >= 0 and y < tileGrid[x].size():
		return true
	else:
		return false

#reads level file and sets board state based on the level file	
func _read_file(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file:
		var lines = file.get_as_text().split("\n")
		#how many top lines to skip when first reading the file
		const skipLines := 2
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
