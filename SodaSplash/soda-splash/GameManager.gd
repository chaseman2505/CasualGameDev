extends Node2D

@onready var textureProgressBar = get_node("TextureProgressBar")
@onready var fillIndicator = get_node("FillIndicator")
var finishedPouring = false
var minLevel = 20.0
var score = 0
var cups = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fillIndicator.position.y = 373.0 - (74.0/100.0 * minLevel)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and finishedPouring == false:
		textureProgressBar.value += 0.1
		if textureProgressBar.value > 100:
			finishedPouring = true
			print("You lose!")
			score = 0
			cups = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pass
			#when left click is released
			else:
				if finishedPouring == true:
					textureProgressBar.value = 0
					fillIndicator.position.y = 373.0 - (74.0/100.0 * minLevel)
					finishedPouring = false
				else:
					finishedPouring = true
					if textureProgressBar.value <= 100 and textureProgressBar.value >= minLevel:
						cups += 1
						score += textureProgressBar.value
						print(cups)
						print(score)
						if minLevel < 95:
							minLevel += 5
						elif minLevel < 99:
							minLevel += 1
					else:
						print("You lose!")
						score = 0
						cups = 0
