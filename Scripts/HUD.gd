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

func _ready():
	set_process(false)
	refreshHUD()

func _process(_delta):
	#Temporary code to restart levels
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()

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

func gameOver():
	#Enables input to restart, should be replaced with death animation then the prompt to restart
	set_process(true)
