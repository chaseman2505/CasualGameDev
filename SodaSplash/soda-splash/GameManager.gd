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
@onready var overFlow1: GPUParticles2D = get_node("Cup1/OverFlow")
@onready var overFlow2: GPUParticles2D = get_node("Cup2/OverFlow")
@onready var overFlow3: GPUParticles2D = get_node("Cup3/OverFlow")

#sounds
@onready var overflowSound := get_node("Sounds/OverflowSound")
var overflowSoundFile = preload("res://Sounds/Overflow.wav")
@onready var pourSound := get_node("Sounds/PourSound")
var pourSoundFile = preload("res://Sounds/Pour2.wav")
@onready var tapSound := get_node("Sounds/TapSound")
var tapSoundFile = preload("res://Sounds/Tap.wav")
@onready var readySound := get_node("Sounds/ReadySound")
var readySoundFile = preload("res://Sounds/Ready.wav")
@onready var conveyorSound := get_node("Sounds/ConveyorSound")
var conveyorSoundFile = preload("res://Sounds/Conveyor2.wav")
@onready var perfectSound := get_node("Sounds/PerfectSound")
var perfectSoundFile = preload("res://Sounds/Perfect.wav")
@onready var greatSound := get_node("Sounds/GreatSound")
var greatSoundFile = preload("res://Sounds/Great.wav")
@onready var goodSound := get_node("Sounds/GoodSound")
var goodSoundFile = preload("res://Sounds/Good.wav")
@onready var scoreTickSound := get_node("Sounds/ScoreTickSound")
var scoreTickSoundFile = preload("res://Sounds/ScoreTick.wav")
var polyphonic = preload("res://Sounds/Polyphonic.tres")
var playback: AudioStreamPlaybackPolyphonic

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
const STAGE2REQUIREMENT := 4
const STAGE3REQUIREMENT := 8
const STAGE4REQUIREMENT := 12

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

#how many cups have been successfully filled in the current run
var cups := 0
var streak := 0
var score := 0
var highscore := 0

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
	overflowSound.stream = overflowSoundFile
	pourSound.stream = pourSoundFile
	tapSound.stream = tapSoundFile
	readySound.stream = readySoundFile
	conveyorSound.stream = conveyorSoundFile
	perfectSound.stream = perfectSoundFile
	greatSound.stream = greatSoundFile
	goodSound.stream = goodSoundFile
	scoreTickSound.stream = polyphonic
	scoreTickSound.play()
	playback = scoreTickSound.get_stream_playback()
	Reset()
	
	
	#reads the highscore file and sets highscore based on browser data
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		highscore = file.get_var()
		file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and pourState == PourState.POURING and resetAnimation == false:
		pourTimer += delta
		if pourTimer >= pourDelay:
			AddLiquid(delta)
			
	elif pourState == PourState.WAITING:
		pourTimer += delta
		pourDelay = CalculatePourDelay()
		
		#if the liquid reached the bottom
		if currentCup.value > 0:
			if pourTimer < pourDelay:
				AddLiquid(delta)
			else:
				pourState = PourState.FINISHED
				MeasureFill()
		#if the liquid hasn't reached the bottom
		else:
			if pourTimer >= pourDelay:
				AddLiquid(delta)
				pourTimer -= pourTimerSnapshot

	if resetAnimation == true:
		ResetAnimation(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#when left click is clicked
			if event.pressed == true:
				#tapSound.play()
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
	currentCup.value += CalculateFillPercentage() * delta
	if (pourSound.playing == false):
		pourSound.play()
	if currentCup.value > 100:
		overflowSound.play()
		pourSound.playing = false
		Lose()

func Lose():
	overflowSound.play()
	pourState = PourState.FINISHED
	UpdateScoreUI(score)
	scoreLabel2.text = "You Lose!"
	screen2.texture = redScreenTexture
	score = 0
	cups = 0
	streak = 0
	minLevel = MINLEVELSTART
	
	
func Reset():
	conveyorSound.play()
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
		
	if stageNumber == 4: 
		sodaFountainNewY = rng.randi_range(-75, -25)
	elif stageNumber == 3:
		sodaFountainNewY = rng.randi_range(-15, 35)
	elif stageNumber == 2:
		sodaFountainNewY = rng.randi_range(65, 110)
	else:
		sodaFountainNewY = rng.randi_range(90, 140)
	
	
func MeasureFill():
	pourSound.playing = false
	
	#if you didn't pour enough to go to the next lexel
	if currentCup.value < minLevel:
		Lose()
	#if you didn't pour too much
	elif currentCup.value <= 100:
		screen2.texture = greenScreenTexture
		if minLevel < 90:
			minLevel += 5
		cups += 1
		
		#the score before adding the new points
		var startScore = score
		var tween = create_tween()
		
		if currentCup.value > 93:
			perfectSound.play()
			streak += 1
			scoreLabel2.text = "Perfect!\n+" + str((2 ** (streak - 1)) * PERFECTBONUS)
			score =  score + (2 ** (streak - 1)) * PERFECTBONUS
			tween.tween_method(UpdateScoreUI, startScore, score, 1.0)
		elif currentCup.value > 83:
			greatSound.play()
			streak = 0
			scoreLabel2.text = "Great!\n+" + str(GREATBONUS)
			score = score + GREATBONUS
			tween.tween_method(UpdateScoreUI, startScore, score, 0.75)
		else:
			goodSound.play()
			streak = 0
			scoreLabel2.text = "Good!\n+" + str(GOODBONUS)
			score = score + GOODBONUS
			tween.tween_method(UpdateScoreUI, startScore, score, 0.5)
		
		scoreTickSound.pitch_scale = 0.85
		
		#updates the highscore file
		if score > highscore:
			highscore = score
			var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
			file.store_var(highscore)
			file.close()

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
		scoreLabel1.text = "Score\n" + str(int(score)) + "\nHighscore\n" + str(highscore)
		scoreLabel2.text = "Perfect\nStreak\n" + str(streak)
		readySound.play()
		pourState = PourState.READY

#switches which cup variant is being used
#also switches lifetime of pour particles
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
#also changes tint of particles -C
func ChangeSodaFountainTint(color):
	sodaFountainSoda.modulate = color
	overFlow1.modulate = color
	overFlow2.modulate = color
	overFlow3.modulate = color
	pourParticle.modulate = color
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
	scoreLabel1.text = "Score\n" + str(int(scoreUpdated)) + "\nHighscore\n" + str(highscore)
	scoreTickSound.pitch_scale += 0.001
	playback.play_stream(scoreTickSoundFile)

#calculates how long it takes the liquid to fall from the fountain
#to the surface of the liquid or the bottom of the cup if there is no liquid
func CalculatePourDelay():
	#return 0
	#return ((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (sodaFountain.texture.get_size().y * sodaFountain.scale.y * 0.5))))/195.072
	return ((currentCup.texture_progress.get_size().y * currentCup.scale.x * (100 - currentCup.value) * 0.01) + (currentCup.position.y - (sodaFountain.position.y + (pourParticle.position.y * sodaFountain.scale.y))))/297.000001408

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
