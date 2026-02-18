extends Node2D

@onready var cup = get_node("Cup")
@onready var scoreLabel = get_node("ScoreLabel")
@onready var fillIndicatorTop = get_node("Cup/FillIndicatorTop")
@onready var fillIndicatorBottom = get_node("Cup/FillIndicatorTop/FillIndicatorBottom")
@onready var loseSound = get_node("Sounds/LoseSound")
@onready var resetSound = get_node("Sounds/ResetSound")
@onready var overflowSound = get_node("Sounds/OverflowSound")
@onready var goodPourSound = get_node("Sounds/GoodPourSound")
@onready var pourSound = get_node("Sounds/PourSound")
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
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and finishedPouring == false and cup.value <= 100:
		cup.value += 50 * delta
		pourSound.play()
		if cup.value > 100:
			Lose()
			overflowSound.play()

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
	loseSound.play()
	scoreLabel.text = "Score: " + str(int(score)) + "\nCups: " + str(cups) + "\nYou Lose!"
	score = 0
	cups = 0
	minLevel = minLevelStart
	
func Reset():
	resetSound.play()
	scoreLabel.text = "Score: " + str(int(score)) + "\nCups: " + str(cups)
	cup.value = 0
	fillIndicatorTop.value = 100 - minLevel
	fillIndicatorBottom.position.y = cup.size.y - (minLevel * 0.01 * cup.size.y) - 219
	finishedPouring = false

func MeasureFill():
	finishedPouring = true
	#if you poured enough to go to the next lexel
	if cup.value <= 100 and cup.value >= minLevel:
		goodPourSound.play()
		cups += 1
		score += cup.value
		scoreLabel.text = "Score: " + str(int(score)) + "\nCups: " + str(cups)
		if minLevel < 95:
			minLevel += 10
		elif minLevel < 99:
			minLevel += 1
	#if you poured too little
	elif cup.value <= 100:
			Lose()
