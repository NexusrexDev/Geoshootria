extends Control

func _ready():
	$VBoxContainer/ScoreLabel.text = "Score: " + str("%06d" % GameManager.currentScore)
	AudioManager.playMusic("res://Assets/Audio/Music/gameEnd.wav")

	yield(get_tree().create_timer(6.5), "timeout")
	GameManager.updateHighScore()
	GameManager.resetGame()


	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	transition.targetScene = "res://Scenes/Rooms/Intro.tscn"
	add_child(transition)