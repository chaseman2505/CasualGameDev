extends Node2D

@onready var scoreLabel = get_node("ScoreLabel")
@onready var conveyorBelt = get_node("ConveyorBelt")
@onready var sodaFountain = get_node("SodaFountain")

@onready var loseSound = get_node("Sounds/LoseSound")
@onready var resetSound = get_node("Sounds/ResetSound")
@onready var overflowSound = get_node("Sounds/OverflowSound")
@onready var goodPourSound = get_node("Sounds/GoodPourSound")
@onready var pourSound = get_node("Sounds/PourSound")

@onready var cup1 = get_node("Cup1")
@onready var fillIndicatorTop1 = get_node("Cup1/FillIndicatorTop")
@onready var fillIndicatorBottom1 = get_node("Cup1/FillIndicatorTop/FillIndicatorBottom")

@onready var cup2 = get_node("Cup2")
@onready var fillIndicatorTop2 = get_node("Cup2/FillIndicatorTop")
@onready var fillIndicatorBottom2 = get_node("Cup2/FillIndicatorTop/FillIndicatorBottom")

#an array of every cup variant
@onready var cupsArray = [cup1, cup2]

#the index of the current cup
var currentCupIndex = 1

#a reference to whichever cup is currently being used
@onready var currentCup = cupsArray[currentCupIndex]
@onready var currentFillIndicatorTop = fillIndicatorTop1
@onready var currentFillIndicatorBottom = fillIndicatorBottom1

const PERFECTBONUS = 50
const GREATBONUS = 25
const GOODBONUS = 10
const MINLEVELSTART = 20

#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
enum PourState {
	READY,
	POURING,
	WAITING,
	FINISHED
}
#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
var pourState = PourState.FINISHED

#the minimum fill level needed to pass the round without losing
var minLevel = MINLEVELSTART

var score = 0
var cups = 0

#how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
var pourDelay = 0.0

#timer used when pouring is compared to pourDelay to know
#when to start and stop adding liquid to the cup
var pourTimer = 0.0

#how fast the cup will fill
var fillRate = 50.0

#if the reset animation is being played
var resetAnimation = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pourState == PourState.POURING and resetAnimation == false:
		#pourSound1.play()
		pourTimer += delta
		if pourTimer >= pourDelay:
			AddLiquid(delta)
	elif pourState == PourState.WAITING:
		pourTimer += delta
		pourDelay = CalculatePourDelay()
		if pourTimer < pourDelay:
			AddLiquid(delta)
		else:
			pourState = PourState.FINISHED
			MeasureFill()
	
	#scoreLabel.text = str(pourState)
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
					pourDelay = CalculatePourDelay()
					pourState = PourState.POURING
					pourTimer = 0
				elif pourState == PourState.FINISHED and resetAnimation == false:
					Reset()
			#when left click is released
			elif pourState == PourState.POURING:
				pourTimer = 0
				pourState = PourState.WAITING

func AddLiquid(delta):
	#pourSound2.play()
	currentCup.value += fillRate * delta
	scoreLabel.text = "Total Score: " + str(int(score)) + " + " + str(int(currentCup.value)) + "\nRound Score: " + str(int(currentCup.value)) + "\nCups: " + str(cups)
	if currentCup.value > 100:
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
	scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: 0" + "\nCups: " + str(cups)
	resetAnimation = true
	currentCup.position.x -= 0.01
	conveyorBelt.texture.pause = false
	currentFillIndicatorTop.visible = false
	
	
	
func MeasureFill():
	#if you didn't pour enough to go to the next lexel
	if currentCup.value < minLevel:
		Lose()
	#if you didn't pour too much
	elif currentCup.value <= 100:
		goodPourSound.play()
		if minLevel < 90:
			minLevel += 10
		cups += 1
		score += cup2.value
		
		if currentCup.value > 98:
			score += PERFECTBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(currentCup.value) + PERFECTBONUS) + "\nCups: " + str(cups) + "\nPerfect +" + str(PERFECTBONUS)
		elif currentCup.value > 95:
			score += GREATBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(currentCup.value) + GREATBONUS) + "\nCups: " + str(cups) + "\nGreat +" + str(GREATBONUS)
		elif currentCup.value > 90:
			score += GOODBONUS
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(currentCup.value) + GOODBONUS) + "\nCups: " + str(cups) + "\nGood +" + str(GOODBONUS)
		else:
			scoreLabel.text = "Total Score: " + str(int(score)) + "\nRound Score: " + str(int(currentCup.value)) + "\nCups: " + str(cups) + "\nOkay"

func ResetAnimation(delta):
	#if the cup is in the screen center
	if is_equal_approx(currentCup.position.x, CalculateCupCenter()):
		conveyorBelt.texture.pause = true
		currentFillIndicatorTop.visible = true
		currentFillIndicatorTop.value = move_toward(currentFillIndicatorTop.value, CalculateFillIndicatorValue(), 200 * delta)
		currentFillIndicatorBottom.position.y = (4.35 * currentFillIndicatorTop.value) - 210
		if currentFillIndicatorTop.value == CalculateFillIndicatorValue():
			resetAnimation = false
			pourState = PourState.READY
	#if the cup is to the left of the screen center
	elif currentCup.position.x < CalculateCupCenter():
		currentCup.position.x -= 640 * delta * 2
		if currentCup.position.x <= -119.2:
			SwitchCup()
	#if the cup is to the right of the screen center
	else:
		currentCup.position.x = move_toward(currentCup.position.x, CalculateCupCenter(), 640 * delta * 2)

#switches which cup variant is being used
func SwitchCup():
	currentCupIndex += 1
	if currentCupIndex >= cupsArray.size():
		currentCupIndex = 0
	if currentCupIndex == 0:
		currentFillIndicatorTop = fillIndicatorTop1
		currentFillIndicatorBottom = fillIndicatorBottom1
	elif currentCupIndex == 1:
		currentFillIndicatorTop = fillIndicatorTop2
		currentFillIndicatorBottom = fillIndicatorBottom2
	currentCup = cupsArray[currentCupIndex]
	currentCup.position.x = 1160.8
	currentCup.value = 0
	currentFillIndicatorTop.value = 0
	currentFillIndicatorTop.visible = false

#calculates how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
func CalculatePourDelay():
	return ((currentCup.size.y * 0.4 * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (sodaFountain.texture.get_size().y * 0.4 * 0.5))))/195.072

#calculates the x position that centers the cup on screen
func CalculateCupCenter():
	return get_viewport().get_visible_rect().size.x/2 - currentCup.size.x * currentCup.scale.x/2

#calculates the value of the fill indicator that matches with minLevel %
func CalculateFillIndicatorValue():
	return currentCup.size.y/currentFillIndicatorTop.size.y * 100 - currentCup.size.y/currentFillIndicatorTop.size.y * minLevel
