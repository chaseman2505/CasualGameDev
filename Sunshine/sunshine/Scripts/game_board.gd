extends Node2D

@onready var tileGrid := [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)"], #this line is column 1 not row 1
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)"], #this line is column 2 not row 2
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)"]  #this line is column 3 not row 3
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(tileGrid.size()):
		for y in range(tileGrid[x].size()):
			tileGrid[x][y].tileGridPosition = Vector2(x, y)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_tile(tile) -> void:
	_update_queuePosition(tile, 0)
	for a in range(tileGrid.size()):
		for b in range(tileGrid[a].size()):
			print(tileGrid[a][b].name + ": " + str(tileGrid[a][b].queuePosition))
	
	
	
	
func _update_queuePosition(tile, iterationNumber) -> void:
	tile.queuePosition = iterationNumber
	var x = tile.tileGridPosition.x
	var y = tile.tileGridPosition.y
	match tile.tileType:
		tile.TileType.TREE:
			var positionsToCheck := [Vector2(x - 1, y - 1), Vector2(x, y - 1), Vector2(x + 1, y - 1), Vector2(x - 1, y), 
			Vector2(x, y), Vector2(x + 1, y), Vector2(x - 1, y + 1), Vector2(x, y + 1), Vector2(x + 1, y + 1)]
			for position in positionsToCheck:
				if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN:
					#_melt_tile(tileGrid[position.x][position.y])
					_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
						
		tile.TileType.RIVER:
			var positionsToCheck := [Vector2(x, y - 1), Vector2(x - 1, y), Vector2(x, y), Vector2(x + 1, y), Vector2(x, y + 1)]
			for position in positionsToCheck:
				if _position_in_bounds(position.x, position.y) and tileGrid[position.x][position.y].tileType == tile.TileType.RIVER and tileGrid[position.x][position.y].tileState == tile.TileState.FROZEN and tile.queuePosition + 1 < tileGrid[position.x][position.y].queuePosition:
					#_melt_tile(tileGrid[position.x][position.y])
					_update_queuePosition(tileGrid[position.x][position.y], iterationNumber + 1)
					
		3, 4:  # multiple values can be matched together
			print("Value is 3 or 4")
			
		_:
			print("Value is something else")  # default case

func _melt_tile(tile) -> void:
	tile.tileState = tile.TileState.MELTED
	tile.modulate.a = 0.5

#returns true if a position is in the bounds of the tileGrid
func _position_in_bounds(x, y) -> bool:
	if x >= 0 and x < tileGrid.size() and y >= 0 and y < tileGrid[x].size():
		return true
	else:
		return false
