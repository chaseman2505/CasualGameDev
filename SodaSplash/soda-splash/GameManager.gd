extends Node2D

@onready var cup = get_node("Cup")
@onready var scoreLabel = get_node("ScoreLabel")
@onready var fillIndicatorTop = get_node("Cup/FillIndicatorTop")
@onready var fillIndicatorBottom = get_node("Cup/FillIndicatorTop/FillIndicatorBottom")
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
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and overflowing == false and finishedPouring == false:
		cup.value += 50 * delta
		scoreLabel.text = "Score: " + str(int(score)) + "\nCups: " + str(cups)
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
	fillIndicatorTop.value = 100 - minLevel
	fillIndicatorBottom.position.y = cup.size.y - (minLevel * 0.01 * cup.size.y) - 219
	finishedPouring = false
	overflowing = false

func MeasureFill():
	finishedPouring = true
	if cup.value <= 100 and cup.value >= minLevel:
		cups += 1
		score += cup.value
		scoreLabel.text = "Score: " + str(int(score)) + "\nCups: " + str(cups)
		if minLevel < 95:
			minLevel += 10
		elif minLevel < 99:
			minLevel += 1
	elif overflowing == false:
			Lose()
