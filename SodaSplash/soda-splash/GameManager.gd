extends Node2D

#miscellaneous game objects
@onready var conveyorBelt := get_node("ConveyorBelt")
@onready var sodaFountain := get_node("SodaFountain")
@onready var sodaFountainSoda = get_node("SodaFountain/SodaFountainSoda")
@onready var scoreLabel1 := get_node("ScoreLabel1")
@onready var scoreLabel2 := get_node("ScoreLabel2")
@onready var screen1 := get_node("Screen1")
@onready var screen2 := get_node("Screen2")
@onready var pourParticle: GPUParticles2D = get_node("SodaFountain/Pour")

#sounds
@onready var loseSound := get_node("Sounds/LoseSound")
@onready var resetSound := get_node("Sounds/ResetSound")
@onready var overflowSound := get_node("Sounds/OverflowSound")
@onready var goodPourSound := get_node("Sounds/GoodPourSound")
@onready var pourSound := get_node("Sounds/PourSound")

#textures
@onready var greenScreenTexture := preload("res://Textures/Miscellaneous/OtherSignGreen.png")
@onready var redScreenTexture := preload("res://Textures/Miscellaneous/OtherSignRed.png")
@onready var blueScreenTexture := preload("res://Textures/Miscellaneous/OtherSign.png")
@onready var grapeFountainTexture = preload("res://Textures/SodaFountains/GrapeFountain/GrapeFountain1.png")
@onready var blueFountainTexture = preload("res://Textures/SodaFountains/BlueFountain/BlueFountain1.png")
@onready var orangeFountainTexture = preload("res://Textures/SodaFountains/OrangeFountain/OrangeFountain1.png")
@onready var cherryFountainTexture = preload("res://Textures/SodaFountains/CherryFountain/CherryFountain1.png")

#cup variants and fill indicator objects
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
var currentCupIndex := 0

#a reference to whichever cup is currently being used
@onready var currentCup = cupsArray[currentCupIndex]
@onready var currentFillIndicatorTop := fillIndicatorTop1
@onready var currentFillIndicatorBottom := fillIndicatorBottom1
var rng := RandomNumberGenerator.new()

#points recieved for each bonus
const PERFECTBONUS := 150
const GREATBONUS := 100
const GOODBONUS := 50

#the colors for each tint
const GRAPETINT := Color(1.39, 0.911, 1.458)
const BLUETINT := Color(0.555, 1.141, 1.865)
const ORANGETINT := Color(2.896, 1.092, 0.612)
const CHERRYTINT := Color(3.046, 0.687, 1.135)

#required number of cups to reach each stage
const STAGE2REQUIREMENT := 1
const STAGE3REQUIREMENT := 2
const STAGE4REQUIREMENT := 3

#starting minimum fill level
const MINLEVELSTART := 20

#if drink is ready to pour, pouring, waiting for leftover liquid to fall, or finished pouring 
enum PourState {
	READY,
	POURING,
	WAITING,
	FINISHED
}
#the current pour state
var pourState := PourState.FINISHED

#if the soda fountain is moving to a new height, stationary, or changing to a different flavor, 
enum SodaFountainState {
	MOVING,
	STATIONARY,
	CHANGINGFLAVOR
}

#the current soda fountain state
var sodaFountainState := SodaFountainState.STATIONARY

#whether the game is on stage 1, 2, 3, or 4
var stageNumber := 1

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

#used to save the state of pourTimer when waiting state is first entered
var pourTimerSnapshot := 0.0

#how fast the cup will fill
#50 means cup1 will fill to 50% in 1 second
var fillRate := 50.0

#the new y position soda fountain will move to
var sodaFountainNewY := 130.0

#if the reset animation is being played
var resetAnimation := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
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
		#print(pourDelay)
		#if the liquid reached the bottom
		if currentCup.value > 0:
			if pourTimer < pourDelay:
				AddLiquid(delta)
			else:
				print(pourDelay)
				print(pourTimer)
				pourState = PourState.FINISHED
				MeasureFill()
		#if the liquid hasn't reached the bottom
		else:
			if pourTimer >= pourDelay:
				AddLiquid(delta)
				pourTimer -= pourTimerSnapshot

	if resetAnimation == true:
		ResetAnimation(delta)
		
	UpdateScoreUI(score)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#when left click is clicked
			if event.pressed == true:
				if pourState == PourState.READY:
					pourDelay = CalculatePourDelay()
					pourState = PourState.POURING
					pourParticle.emitting = true
					pourTimer = 0
				elif pourState == PourState.FINISHED and resetAnimation == false:
					
					Reset()
			#when left click is released
			elif pourState == PourState.POURING:
				pourParticle.emitting = false
				pourState = PourState.WAITING
				pourTimerSnapshot = pourTimer
				if currentCup.value > 0:
					pourTimer = 0

func AddLiquid(delta):
	#pourSound2.play()
	currentCup.value += CalculateFillPercentage() * delta
	UpdateScoreUI(score)
	if currentCup.value > 100:
		Lose()
		overflowSound.play()

func Lose():
	#loseSound.play()
	pourState = PourState.FINISHED
	UpdateScoreUI(score)
	scoreLabel2.text = "You Lose!"
	screen2.texture = redScreenTexture
	score = 0
	cups = 0
	streak = 0
	minLevel = MINLEVELSTART
	
	
func Reset():
	#resetSound.play()
	currentCup.position.x -= 0.01
	resetAnimation = true
	conveyorBelt.texture.pause = false
	currentFillIndicatorTop.visible = false
	currentFillIndicatorTop.value = 0
	
	if cups >= STAGE4REQUIREMENT:
		stageNumber = 4
	elif cups >= STAGE3REQUIREMENT:
		stageNumber = 3
	elif cups >= STAGE2REQUIREMENT:
		stageNumber = 2
	else:
		stageNumber = 1
		
	if cups == STAGE4REQUIREMENT or cups == STAGE3REQUIREMENT or cups == STAGE2REQUIREMENT or (cups == 0 and sodaFountain.texture != grapeFountainTexture):
		sodaFountainState = SodaFountainState.CHANGINGFLAVOR
	else:
		sodaFountainState = SodaFountainState.MOVING
	
	return
	if stageNumber == 4: 
		sodaFountainNewY = rng.randi_range(-75, 140)
	elif stageNumber == 3:
		sodaFountainNewY = rng.randi_range(0, 140)
	elif stageNumber == 2:
		sodaFountainNewY = rng.randi_range(75, 140)
	else:
		sodaFountainNewY = rng.randi_range(125, 140)
	
	
func MeasureFill():
	#if you didn't pour enough to go to the next lexel
	if currentCup.value < minLevel:
		Lose()
	#if you didn't pour too much
	elif currentCup.value <= 100:
		#goodPourSound.play()
		screen2.texture = greenScreenTexture
		if minLevel < 90:
			minLevel += 10
		cups += 1
		
		#the score before adding the new points
		var startScore = score
		#the score after adding the new points
		var endScore
		
		if currentCup.value > 95:
			streak += 1
			scoreLabel2.text = "Perfect!\n+" + str((2 ** (streak - 1)) * PERFECTBONUS)
			endScore =  score + (2 ** (streak - 1)) * PERFECTBONUS
		elif currentCup.value > 90:
			streak = 0
			scoreLabel2.text = "Great!\n+" + str(GREATBONUS)
			endScore = score + GREATBONUS
		else:
			streak = 0
			scoreLabel2.text = "Good!\n+" + str(GOODBONUS)
			endScore = score + GOODBONUS
		
		var tween = create_tween()
		tween.tween_method(UpdateScoreUI, startScore, endScore, 0.5)

func ResetAnimation(delta):
	#if the cup is in the screen center
	if is_equal_approx(currentCup.position.x, CalculateCupCenter()):
		conveyorBelt.texture.pause = true
		currentFillIndicatorTop.visible = true
		currentFillIndicatorTop.value = move_toward(currentFillIndicatorTop.value, CalculateFillIndicatorValue(), 200 * delta)
		currentFillIndicatorBottom.position.y = (4.35 * currentFillIndicatorTop.value) - 210
	#if the cup is to the left of the screen center
	elif currentCup.position.x < CalculateCupCenter():
		currentCup.position.x -= 640 * delta * 2
		if currentCup.position.x <= -119.2:
			SwitchCup()
	#if the cup is to the right of the screen center
	else:
		currentCup.position.x = move_toward(currentCup.position.x, CalculateCupCenter(), 640 * delta * 2)
		
	if sodaFountainState == SodaFountainState.CHANGINGFLAVOR:
		sodaFountain.position.y = move_toward(sodaFountain.position.y, -140, 400 * delta)
		if is_equal_approx(sodaFountain.position.y, -140):
			sodaFountainState = SodaFountainState.MOVING
			if cups == STAGE4REQUIREMENT:
				ChangeSodaFountainTint(CHERRYTINT)
			elif cups == STAGE3REQUIREMENT:
				ChangeSodaFountainTint(ORANGETINT)
			elif cups == STAGE2REQUIREMENT:
				ChangeSodaFountainTint(BLUETINT)
			else:
				ChangeSodaFountainTint(GRAPETINT)
	elif sodaFountainState == SodaFountainState.MOVING:
		sodaFountain.position.y = move_toward(sodaFountain.position.y, sodaFountainNewY, 400 * delta)
		if is_equal_approx(sodaFountain.position.y, sodaFountainNewY):
			sodaFountainState = SodaFountainState.STATIONARY
	elif sodaFountainState == SodaFountainState.STATIONARY and currentFillIndicatorTop.value == CalculateFillIndicatorValue():
		resetAnimation = false
		screen2.texture = blueScreenTexture
		UpdateScoreUI(score)
		scoreLabel2.text = "Perfect\nStreak\n" + str(streak)
		pourState = PourState.READY
		print((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (255 * sodaFountain.scale.y))))

#switches which cup variant is being used
func SwitchCup():
	#currentCupIndex = rng.randi_range(0, 2)
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
	if stageNumber == 1:
		ChangeCupTint(GRAPETINT)
	elif stageNumber == 2:
		ChangeCupTint(BLUETINT)
	elif stageNumber == 3:
		ChangeCupTint(ORANGETINT)
	elif stageNumber == 4:
		ChangeCupTint(CHERRYTINT)

#changes the tint of all cups
func ChangeCupTint(color):
	cup1.tint_progress = color
	cup2.tint_progress = color
	cup3.tint_progress = color

#changes the tint of the soda fountain
func ChangeSodaFountainTint(color):
	sodaFountainSoda.modulate = color
	if color == GRAPETINT:
		sodaFountain.texture = grapeFountainTexture
	elif color == BLUETINT:
		sodaFountain.texture = blueFountainTexture
	elif color == ORANGETINT:
		sodaFountain.texture = orangeFountainTexture
	elif color == CHERRYTINT:
		sodaFountain.texture = cherryFountainTexture

#updates the UI displaying the score
func UpdateScoreUI(scoreUpdated):
	scoreLabel1.text = "Score\n" + str(int(scoreUpdated)) + "\nCups\n" + str(cups) + "\n" + str(pourTimer)

#calculates how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
func CalculatePourDelay():
	#return 0
	#return ((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (sodaFountain.texture.get_size().y * sodaFountain.scale.y * 0.5))))/195.072
	return ((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (255 * sodaFountain.scale.y))))/297.000001408

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
