# HUD.gd
extends CanvasLayer

# Variables
var health : int = 3
var score : int = 0
var highscore : int = 0
var highscoreBroken = false
var highscoreFile = "user://highscore.save"

onready var healthLabel = $Game/HealthLabel
onready var scoreLabel = $Game/ScoreLabel
onready var hscoreLabel = $Game/HighscoreLabel
onready var pauseNode = $Pause

func _ready():
	readHighscore()
	refreshScore()
	refreshHealth()

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

func readHighscore():
	var file = File.new()
	if file.file_exists(highscoreFile):
		file.open(highscoreFile, File.READ)
		highscore = file.get_var()
		file.close()

func refreshHealth():
	# Updates the health-related nodes, expect changing when using a new UI
	healthLabel.text = "Health: " + str(health)

func refreshScore():
	# Updates the score-related labels
	scoreLabel.text = "Score: " + formatConv(score)
	hscoreLabel.text = "Highscore: " + formatConv(highscore)

func formatConv(number):
	# Turns a number into a six digit string
	var numberString = ""
	number = str(number)
	var zeroes = 6 - number.length()
	if zeroes > 0:
		for i in zeroes:
			numberString += "0"
	numberString += number
	return numberString

func healthUpdate(value):
	# Connected to a signal, when the player's health is updated
	health = value
	refreshHealth()

func scoreUpdate(value):
	# Connected to a signal, when an enemy is dead
	score += value
	# Update the highscore if the current score is higher
	if score > highscore:
		highscore = score
		highscoreBroken = true
	refreshScore()

func gameOver():
	var gmovr_scoreLabel = $GameOver/Menu/ScoreLabel
	var gmovr_highscoreLabel = $GameOver/Menu/HighscoreLabel
	# Disabling the pause menu
	set_process(false)

	# In case of a new highscore, it's saved to the file and the label is adjusted
	if highscoreBroken:
		var file = File.new()
		file.open(highscoreFile, File.WRITE)
		file.store_var(highscore)
		file.close()
		gmovr_highscoreLabel.text = "New Highscore!"
	else:
		gmovr_highscoreLabel.text = "Highscore: " + str(highscore)
	
	# Setting the score label in advance
	gmovr_scoreLabel.text = str(score)

	# Stopping the spawner
	var spawner = get_node("/root/Level/Spawner")
	spawner.stopSpawner()

	# Playing the game over animation
	var animPlayer = get_node("/root/Level/AnimationPlayer")
	animPlayer.play("GameOver")


func mainPressed():
	get_tree().change_scene("res://Scenes/Rooms/MainMenu.tscn")

func replayPressed():
	get_tree().change_scene("res://Scenes/Rooms/Level.tscn")
