extends Node2D

@onready var cup = get_node("Cup")
@onready var fillIndicatorTop = get_node("Cup/FillIndicatorTop")
@onready var fillIndicatorBottom = get_node("Cup/FillIndicatorBottom")
var finishedPouring = false
var overflowing = false
var minLevelStart = 20
var minLevel = minLevelStart
var score = 0
var cups = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and overflowing == false:
		cup.value += 0.1
		fillIndicatorTop.value -=0.1
		if cup.value > 100:
			Lose()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#when left click is released
			if event.pressed == false:
				if finishedPouring == true:
					Reset()
				else:
					MeasureFill()

func Lose():
	print("You Lose!")
	score = 0
	cups = 0
	minLevel = minLevelStart
	overflowing = true
	
func Reset():
	cup.value = 0
	fillIndicatorTop.value = 80
	fillIndicatorBottom.position.y = cup.size.y - (cup.size.y/100.0 * minLevel)
	finishedPouring = false
	overflowing = false

func MeasureFill():
	finishedPouring = true
	if cup.value <= 100 and cup.value >= minLevel:
		cups += 1
		score += cup.value
		print(cups)
		print(score)
		if minLevel < 95:
			minLevel += 5
		elif minLevel < 99:
			minLevel += 1
	elif overflowing == false:
			Lose()
