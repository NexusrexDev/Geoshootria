extends Node2D

func _ready():
	self.call_deferred("startAnim")

func startAnim():
	$AnimationPlayer.play("intro")


func playJingle():
	AudioManager.playMusic("res://Assets/Audio/Music/nexJingle.wav")


func fadeOut():
	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	transition.targetScene = "res://Scenes/Rooms/MainMenu.tscn"
	add_child(transition)
