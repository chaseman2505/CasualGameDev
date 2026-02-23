extends Node2D

@onready var cup = get_node("Cup")
@onready var scoreLabel = get_node("ScoreLabel")
@onready var fillIndicatorTop = get_node("Cup/FillIndicatorTop")
@onready var fillIndicatorBottom = get_node("Cup/FillIndicatorTop/FillIndicatorBottom")
@onready var conveyorBelt = get_node("ConveyorBelt")

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
var pourDelay = 1
var finishedPouring = false
var resetAnimation = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and finishedPouring == false and cup.value <= 100 and resetAnimation == false:
		cup.value += 50 * delta
		pourSound.play()
		scoreLabel.text = "Total Score: " + str(int(score)) + " + " + str(int(cup.value)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups)
		if cup.value > 100:
			Lose()
			overflowSound.play()
			
#	cup.position.x = move_toward(cup.position.x, 520.8, 640 * delta * 2)
#	print(cup.position.x)

	if resetAnimation == true:
		#if the cup is in the screen center
		if is_equal_approx(cup.position.x, 520.8):
			conveyorBelt.texture.pause = true
			fillIndicatorTop.visible = true
			fillIndicatorTop.value = move_toward(fillIndicatorTop.value, 100 - minLevel, 200 * delta)
			fillIndicatorBottom.position.y = (4.35 * fillIndicatorTop.value) - 210
			if fillIndicatorTop.value == 100 - minLevel:
				resetAnimation = false
		#if the cup is to the left of the screen center
		elif cup.position.x < 520.8:
			cup.position.x = move_toward(cup.position.x, -119.2, 640 * delta * 2)
			if is_equal_approx(cup.position.x, -119.2):
				cup.position.x = 1160.8
		#if the cup is to the right of the screen center
		else:
			cup.position.x = move_toward(cup.position.x, 520.8, 640 * delta * 2)
			

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
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: 0" + "\nCups: " + str(cups) + "\nYou Lose!"
	score = 0
	cups = 0
	minLevel = MINLEVELSTART
	
	
func Reset():
	resetSound.play()
	cup.value = 3
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: 0" + "\nCups: " + str(cups)
	fillIndicatorTop.value = 0
	finishedPouring = false
	resetAnimation = true
	cup.position.x -= 0.01
	conveyorBelt.texture.pause = false
	fillIndicatorTop.visible = false
	
	
func MeasureFill():
	finishedPouring = true
	#if you didn't pour enough to go to the next lexel
	if cup.value < minLevel:
		Lose()
	#if you didn't pour too much
	elif cup.value <= 100:
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
