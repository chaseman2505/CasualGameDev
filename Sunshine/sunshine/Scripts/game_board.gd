extends Node2D

@onready var tileArray:= [
	[$"Tile(0,0)", $"Tile(0,1)", $"Tile(0,2)"],
	[$"Tile(1,0)", $"Tile(1,1)", $"Tile(1,2)"],
	[$"Tile(2,0)", $"Tile(2,1)", $"Tile(2,2)"]
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for row in range(tileArray.size()):
		#for column in range(tileArray[row].size()):
			#tileArray[row][column].tile_pressed.connect(_on_tile_pressed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _tile_pressed(tile) -> void:
	tile._update_tile()
