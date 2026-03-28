extends Node2D

@onready var tileGrid := [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)"], #column 1
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)"], #column 2
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)"]  #column 3
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(tileGrid.size()):
		for y in range(tileGrid[x].size()):
			#tileArray[row][column].tile_pressed.connect(_on_tile_pressed)
			tileGrid[x][y].tileGridPosition = Vector2(x, y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _tile_pressed(tileGridPosition) -> void:
	print(tileGridPosition)
	var x = tileGridPosition.x
	var y = tileGridPosition.y
	var tile = tileGrid[x][y]
	tile._update_tile()
	match tile.tileType:
		tile.TileType.TREE:
			_update_tile_if_valid(x - 1, y - 1)
			_update_tile_if_valid(x, y - 1)
			_update_tile_if_valid(x + 1, y - 1)
			_update_tile_if_valid(x - 1, y)
			_update_tile_if_valid(x + 1, y)
			_update_tile_if_valid(x - 1, y + 1)
			_update_tile_if_valid(x, y + 1)
			_update_tile_if_valid(x + 1, y + 1)
		2:
			print("Value is 2")
		3, 4:  # multiple values can be matched together
			print("Value is 3 or 4")
		_:
			print("Value is something else")  # default case

func _update_tile_if_valid(x, y):
	if x >= 0 and x < tileGrid.size() and y >= 0 and y < tileGrid[x].size():
		tileGrid[x][y]._update_tile()
