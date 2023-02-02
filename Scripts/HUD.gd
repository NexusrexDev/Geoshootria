# HUD.gd
extends CanvasLayer

# Variables
var health = 3
var score = 0
var scoreString = ""
var highscore = 0
var hscoreString = ""

onready var healthLabel = $HealthLabel
onready var scoreLabel = $ScoreLabel
onready var hscoreLabel = $HighscoreLabel
onready var pauseNode = $Pause

func _ready():
	refreshHUD()

func _process(_delta):
	# Pausing
	if Input.is_action_just_pressed("ui_select"):
		var isPaused = get_tree().paused
		get_tree().paused = !isPaused
		pauseNode.visible = !isPaused
		if !isPaused == true:
			AudioServer.add_bus_effect(1, AudioEffectBandPassFilter.new())
		else:
			AudioServer.remove_bus_effect(1, 0)

func refreshHUD():
	scoreString = formatConv(score)
	hscoreString = formatConv(highscore)
	healthLabel.text = "Health: " + str(health)
	scoreLabel.text = "Score: " + scoreString
	hscoreLabel.text = "Highscore: " + hscoreString

func formatConv(number):
	var numberString = ""
	number = str(number)
	var zeroes = 6 - number.length()
	if zeroes > 0:
		for i in zeroes:
			numberString += "0"
	numberString += number
	return numberString

func healthUpdate(value):
	health = value
	refreshHUD()

func scoreUpdate(value):
	score += value
	# Update the highscore if the current score is bigger
	if score > highscore:
		highscore = score
	refreshHUD()

func gameOver():
	#Enables input to restart, should be replaced with death animation then the prompt to restart
	set_process(true)
	#var spawner = get_node("/root/Level/Spawner")
	#spawner.stopSpawner()
