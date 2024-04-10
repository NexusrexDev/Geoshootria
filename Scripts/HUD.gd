# HUD.gd
extends MarginContainer

# Variables


var currentScene: Node

onready var healthBar : TextureRect = $Game/HealthBar
onready var scoreLabel : Label = $Game/ScoreLabel
onready var hscoreLabel : Label = $Game/HighscoreLabel
onready var pauseNode : Control = $Pause
onready var bossHP: TextureProgress = $BossHP/TextureProgress

func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

	GameManager.connect("scoreChanged", self, "refreshScore")

	refreshScore()
	healthUpdate(3)

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


func refreshScore():
	# Updates the score-related labels
	scoreLabel.text = "Score: " + str("%06d" % GameManager.currentScore)
	hscoreLabel.text = "Highscore: " + str("%06d" % GameManager.highScore)


func healthUpdate(value):
	# Connected to a signal, when the player's health is updated
	healthBar.texture.region = Rect2(49 * (3 - value), 0, 49, 12)


func bossUpdate(value):
	# Connected to a signal, when the boss's health is updated
	bossHP.value = value

func gameOver():
	var gmovr_scoreLabel = $GameOver/Menu/ScoresContainer/ScoreLabel
	var gmovr_highscoreLabel = $GameOver/Menu/ScoresContainer/HighscoreLabel
	# Disabling the pause menu
	set_process(false)

	# In case of a new highscore, it's saved to the file and the label is adjusted
	if GameManager.highscoreBroken:
		GameManager.updateHighScore()
		gmovr_highscoreLabel.text = "New Highscore!"
	else:
		gmovr_highscoreLabel.text = "Highscore: " + str("%06d" % GameManager.highScore)
	
	# Setting the score label in advance
	gmovr_scoreLabel.text = "Score: " + str("%06d" % GameManager.currentScore)

	# Stopping the spawner
	var spawner = currentScene.get_node("Spawner")
	spawner.stopSpawner()

	# Playing the game over animation
	var animPlayer = currentScene.get_node("AnimationPlayer")
	animPlayer.play("GameOver")
	yield(animPlayer, "animation_finished")
	get_tree().call_group("enemy", "queue_free")


func mainPressed():
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	$GameOver/Menu/VBoxContainer/MenuReturn.release_focus()
	GameManager.resetGame()
	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	transition.targetScene = "res://Scenes/Rooms/MainMenu.tscn"
	add_child(transition)

func replayPressed():
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	$GameOver/Menu/VBoxContainer/Replay.release_focus()
	GameManager.resetScore()
	GameManager.deathCount = true
	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	transition.targetScene = GameManager.levelPaths[GameManager.currentLevel]
	add_child(transition)
