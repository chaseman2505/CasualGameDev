extends Node2D

@onready var tileGrid := [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)"], #this line is column 1 not row 1
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)"], #this line is column 2 not row 2
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)"]  #this line is column 3 not row 3
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
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if updatesOccuring:
		timer -= delta
		if timer <= 0:
			var anyTilesLeftToUpdate := false
			for x in range(tileGrid.size()):
				for y in range(tileGrid[x].size()):
					if tileGrid[x][y].queuePosition == 0:
						_update_tile(x, y)
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
	tile.queuePosition = iterationNumber
	var x = tile.tileGridPosition.x
	var y = tile.tileGridPosition.y
	match tile.tileType:
		tile.TileType.TREE:
			var positionsToCheck := [Vector2(x - 1, y - 1), Vector2(x, y - 1), Vector2(x + 1, y - 1), Vector2(x - 1, y), 
			Vector2(x + 1, y), Vector2(x - 1, y + 1), Vector2(x, y + 1), Vector2(x + 1, y + 1)]
			for position in positionsToCheck:
				if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN:
					tileGrid[position.x][position.y].queuePosition = 1
						
		tile.TileType.RIVER:
			var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x + 1, y), Vector2(x, y + 1)]
			for position in positionsToCheck:
				if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.RIVER and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and (tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition or tileGrid[position.x][position.y].queuePosition == -1):
					_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
					
		3, 4:  # multiple values can be matched together
			print("Value is 3 or 4")
			
		_:
			print("Value is something else")  # default case

#
func _update_tile(x, y) -> void:
	tileGrid[x][y].tileState = tileGrid[x][y].TileState.MELTED
	tileGrid[x][y].modulate.a = 0.5
	tileGrid[x][y].queuePosition -= 1

#returns true if a position is in the bounds of the tileGrid
func _position_in_bounds(x, y) -> bool:
	if x >= 0 and x < tileGrid.size() and y >= 0 and y < tileGrid[x].size():
		return true
	else:
		return false
