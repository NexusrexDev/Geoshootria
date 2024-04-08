extends Control

func _ready():
	HideAll()
	AudioManager.playMusic("res://Assets/Audio/Music/winJingle.wav")
	yield(get_tree().create_timer(0.5), "timeout")
	ShowValues()


func ShowValues():
	var methods = ["ShowScore", "ShowDamage", "ShowDeath", "ShowTotal"]
	for method in methods:
		if method == "ShowDeath" and GameManager.currentLevel == 0:
			continue
		self.call(method)
		yield(get_tree().create_timer(0.6), "timeout")
	
	$Continue.grab_focus()


func HideAll():
	$Values/ScoreBox.visible = false
	$Values/DamageBox.visible = false
	$Values/DeathBox.visible = false
	$Values/TotalBox.visible = false


func ShowScore():
	$Values/ScoreBox/ScoreTally.text = str("%06d" % GameManager.currentScore)
	$Values/ScoreBox.visible = true


func ShowDamage():
	if !GameManager.damageCount:
		$Values/DamageBox/DamageTally.text = "001000"
		GameManager.addScore(1000)
		#Sound effect goes here
	$Values/DamageBox.visible = true


func ShowDeath():
	if !GameManager.deathCount:
		$Values/DeathBox/DeathTally.text = "003000"
		GameManager.addScore(3000)
		#Sound effect goes here
	$Values/DeathBox.visible = true


func ShowTotal():
	$Values/TotalBox/TotalTally.text = str("%06d" % GameManager.currentScore)
	$Values/TotalBox.visible = true


func continuePressed():
	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	match GameManager.currentLevel:
		0:
			GameManager.currentLevel = 1
			GameManager.damageCount = false
			transition.targetScene = GameManager.levelPaths[GameManager.currentLevel]
		1:
			transition.targetScene = "res://Scenes/Rooms/GameEnd.tscn"

	add_child(transition)
