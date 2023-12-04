extends AnimationPlayer

# This holds methods to call when playing music for the gameplay/gameover situations
func mainMusic():
	AudioManager.playMusic("res://Assets/Prototype/Audio/gamefirst.ogg")

func gameoverMusic():
	AudioManager.playMusic("res://Assets/Prototype/Audio/gameovertheme.ogg",1)