extends Node2D

@onready var cup = get_node("Cup")
@onready var scoreLabel = get_node("ScoreLabel")
@onready var fillIndicatorTop = get_node("Cup/FillIndicatorTop")
@onready var fillIndicatorBottom = get_node("Cup/FillIndicatorTop/FillIndicatorBottom")
@onready var conveyorBelt = get_node("ConveyorBelt")
@onready var sodaFountain = get_node("SodaFountain")

@onready var loseSound = get_node("Sounds/LoseSound")
@onready var resetSound = get_node("Sounds/ResetSound")
@onready var overflowSound = get_node("Sounds/OverflowSound")
@onready var goodPourSound = get_node("Sounds/GoodPourSound")
@onready var pourSound = get_node("Sounds/PourSound")

#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
enum PourState {
	READY,
	POURING,
	WAITING,
	FINISHED
}

const PERFECTBONUS = 50
const GREATBONUS = 25
const GOODBONUS = 10
const MINLEVELSTART = 20

var minLevel = MINLEVELSTART
var score = 0
var cups = 0

#how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup
var pourDelay = 0.0
var pourTimer = 0.0

var pourState = PourState.FINISHED
var resetAnimation = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pourDelay = CalculatePourDelay()
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pourState == PourState.POURING and resetAnimation == false:
		#pourSound1.play()
		pourTimer += delta
		if pourTimer >= pourDelay:
			AddLiquid(delta)
	elif pourState == PourState.WAITING:
		if pourTimer < pourDelay:
			pourDelay = CalculatePourDelay()
			AddLiquid(delta)
			pourTimer += delta
		else:
			pourState = PourState.FINISHED
			MeasureFill()
	
	scoreLabel.text = str(pourState)
#	cup.position.x = move_toward(cup.position.x, 520.8, 640 * delta * 2)
#	print(cup.position.x)

	if resetAnimation == true:
		ResetAnimation(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#when left click is clicked
			if event.pressed == true:
				if pourState == PourState.READY:
					pourState = PourState.POURING
					pourTimer = 0
				elif pourState == PourState.FINISHED:
					Reset()
			#when left click is released
			elif pourState == PourState.POURING:
				pourTimer = 0
				pourState = PourState.WAITING

func AddLiquid(delta):
	#pourSound2.play()
	cup.value += 50 * delta
	scoreLabel.text = "Total Score: " + str(int(score)) + " + " + str(int(cup.value)) + "\nRound Score: " + str(int(cup.value)) + "\nCups: " + str(cups)
	if cup.value > 100:
		Lose()
		overflowSound.play()

func Lose():
	loseSound.play()
	pourState = PourState.FINISHED
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: 0" + "\nCups: " + str(cups) + "\nYou Lose!"
	score = 0
	cups = 0
	minLevel = MINLEVELSTART
	
	
func Reset():
	resetSound.play()
	cup.value = 3
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: 0" + "\nCups: " + str(cups)
	fillIndicatorTop.value = 0
	resetAnimation = true
	cup.position.x -= 0.01
	conveyorBelt.texture.pause = false
	fillIndicatorTop.visible = false
	pourDelay = CalculatePourDelay()
	
	
	
func MeasureFill():
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

func ResetAnimation(delta):
	#if the cup is in the screen center
	if is_equal_approx(cup.position.x, 520.8):
		conveyorBelt.texture.pause = true
		fillIndicatorTop.visible = true
		fillIndicatorTop.value = move_toward(fillIndicatorTop.value, 100 - minLevel, 200 * delta)
		fillIndicatorBottom.position.y = (4.35 * fillIndicatorTop.value) - 210
		if fillIndicatorTop.value == 100 - minLevel:
			resetAnimation = false
			pourState = PourState.READY
	#if the cup is to the left of the screen center
	elif cup.position.x < 520.8:
		cup.position.x = move_toward(cup.position.x, -119.2, 640 * delta * 2)
		if is_equal_approx(cup.position.x, -119.2):
			cup.position.x = 1160.8
	#if the cup is to the right of the screen center
	else:
		cup.position.x = move_toward(cup.position.x, 520.8, 640 * delta * 2)
		
func CalculatePourDelay():
	return ((cup.size.y * 0.4 * (100 - cup.value) * 0.01) + (cup.position.y - (sodaFountain.position.y + (sodaFountain.texture.get_size().y * 0.4 * 0.5))))/195.072
