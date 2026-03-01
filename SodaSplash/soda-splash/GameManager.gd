extends Node2D

@onready var scoreLabel1 := get_node("ScoreLabel1")
@onready var scoreLabel2 := get_node("ScoreLabel2")
@onready var conveyorBelt := get_node("ConveyorBelt")
@onready var sodaFountain := get_node("SodaFountain")

@onready var loseSound := get_node("Sounds/LoseSound")
@onready var resetSound := get_node("Sounds/ResetSound")
@onready var overflowSound := get_node("Sounds/OverflowSound")
@onready var goodPourSound := get_node("Sounds/GoodPourSound")
@onready var pourSound := get_node("Sounds/PourSound")

@onready var cup1 := get_node("Cup1")
@onready var fillIndicatorTop1 := get_node("Cup1/FillIndicatorTop")
@onready var fillIndicatorBottom1 := get_node("Cup1/FillIndicatorTop/FillIndicatorBottom")

@onready var cup2 := get_node("Cup2")
@onready var fillIndicatorTop2 := get_node("Cup2/FillIndicatorTop")
@onready var fillIndicatorBottom2 := get_node("Cup2/FillIndicatorTop/FillIndicatorBottom")

@onready var cup3 := get_node("Cup3")
@onready var fillIndicatorTop3 := get_node("Cup3/FillIndicatorTop")
@onready var fillIndicatorBottom3 := get_node("Cup3/FillIndicatorTop/FillIndicatorBottom")

#an array of every cup variant
@onready var cupsArray := [cup1, cup2, cup3]

#the index of the current cup
var currentCupIndex := 2

#a reference to whichever cup is currently being used
@onready var currentCup = cupsArray[currentCupIndex]
@onready var currentFillIndicatorTop := fillIndicatorTop1
@onready var currentFillIndicatorBottom := fillIndicatorBottom1
var rng := RandomNumberGenerator.new()

const PERFECTBONUS := 50
const GREATBONUS := 25
const GOODBONUS := 10
const MINLEVELSTART := 20

#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
enum PourState {
	READY,
	POURING,
	WAITING,
	FINISHED
}
#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
var pourState := PourState.FINISHED

#the minimum fill level % needed to pass the round without losing
var minLevel := MINLEVELSTART

var score := 0
var cups := 0
var streak := 0

#how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
var pourDelay := 0.0

#timer used when pouring is compared to pourDelay to know
#when to start and stop adding liquid to the cup
var pourTimer := 0.0

#how fast the cup will fill
#50 means cup1 will fill to 50% in 1 second
var fillRate := 50.0

#if the reset animation is being played
var resetAnimation := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	#sodaFountain.modulate = Color(1.39, 0.911, 1.458)
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
	currentCup.value += CalculateFillPercentage() * delta
	scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
	if currentCup.value > 100:
		Lose()
		overflowSound.play()

func Lose():
	loseSound.play()
	pourState = PourState.FINISHED
	scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
	scoreLabel2.text = "You Lose!"
	score = 0
	cups = 0
	streak = 0
	minLevel = MINLEVELSTART
	
	
func Reset():
	resetSound.play()
	scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
	scoreLabel2.text = "Perfect\nStreak\n" + str(streak)
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
		#goodPourSound.play()
		if minLevel < 90:
			minLevel += 10
		cups += 1
		
		if currentCup.value > 95:
			streak += 1
			score += (2 ** (streak - 1)) * PERFECTBONUS
			scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
			scoreLabel2.text = "Perfect!\n+" + str((2 ** (streak - 1)) * PERFECTBONUS)
		elif currentCup.value > 90:
			streak = 0
			score += GREATBONUS
			scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
			scoreLabel2.text = "Great!\n+" + str(GREATBONUS)
		else:
			streak = 0
			score += GOODBONUS
			scoreLabel1.text = "Score\n" + str(int(score)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)
			scoreLabel2.text = "Good!\n+" + str(GOODBONUS)

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
	currentCupIndex = rng.randi_range(0, 2)
	if currentCupIndex == 0:
		currentFillIndicatorTop = fillIndicatorTop1
		currentFillIndicatorBottom = fillIndicatorBottom1
	elif currentCupIndex == 1:
		currentFillIndicatorTop = fillIndicatorTop2
		currentFillIndicatorBottom = fillIndicatorBottom2
	elif currentCupIndex == 2:
		currentFillIndicatorTop = fillIndicatorTop3
		currentFillIndicatorBottom = fillIndicatorBottom3
	currentCup = cupsArray[currentCupIndex]
	currentCup.position.x = 1160.8
	currentCup.value = 0
	currentFillIndicatorTop.value = 0
	currentFillIndicatorTop.visible = false

#calculates how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
func CalculatePourDelay():
	return 0
	#return ((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (sodaFountain.texture.get_size().y * sodaFountain.scale * 0.5))))/195.072

#calculates the x position that centers the cup on screen
func CalculateCupCenter():
	return get_viewport().get_visible_rect().size.x/2 - currentCup.size.x * currentCup.scale.x/2

#calculates the value of the fill indicator that matches with minLevel %
func CalculateFillIndicatorValue():
	return currentCup.texture_progress.get_size().y/currentFillIndicatorTop.size.y * 100 - currentCup.texture_progress.get_size().y/currentFillIndicatorTop.size.y * minLevel

#calculates the fill percentage for a cup that fills it with the same amount
#of liquid as if that percentage was filling for cup1
func CalculateFillPercentage():
	return fillRate * cup1.texture_progress.get_size().y / currentCup.texture_progress.get_size().y
