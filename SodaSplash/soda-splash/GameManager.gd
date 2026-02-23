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

const PERFECTBONUS = 50
const GREATBONUS = 25
const GOODBONUS = 10
const MINLEVELSTART = 20

var minLevel = MINLEVELSTART
var score = 0
var cups = 0
var finishedPouring = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and finishedPouring == false and cup.value <= 100:
		cup.value += 50 * delta
		pourSound.play()
		scoreLabel.text = "Total Score: " + str(int(score)) + " + " + str(int(cup.value)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups)
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
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups) + "\nYou Lose!"
	score = 0
	cups = 0
	minLevel = MINLEVELSTART
	
func Reset():
	resetSound.play()
	cup.value = 0
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups)
	fillIndicatorTop.value = 100 - minLevel
	fillIndicatorBottom.position.y = cup.size.y - (minLevel * 0.01 * cup.size.y) - 219
	finishedPouring = false

func MeasureFill():
	finishedPouring = true
	#if you didn't pour enough to go to the next lexel
	if cup.value < minLevel:
		Lose()
	else:
		goodPourSound.play()
		if minLevel < 90:
			minLevel += 10
		cups += 1
		score += cup.value
		
		if cup.value > 98:
			score += PERFECTBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value) + PERFECTBONUS) + "\nCups: " + str(cups) + "\nPerfect +" + str(PERFECTBONUS)
		elif cup.value > 95:
			score += GREATBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value) + GREATBONUS) + "\nCups: " + str(cups) + "\nGreat +" + str(GREATBONUS)
		elif cup.value > 90:
			score += GOODBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value) + GOODBONUS) + "\nCups: " + str(cups) + "\nGood +" + str(GOODBONUS)
		else:
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups) + "\nOkay"
