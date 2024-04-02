extends AnimationPlayer

# This holds methods to call when playing music for the gameplay/gameover situations
func mainMusic():
	AudioManager.playMusic("res://Assets/Prototype/Audio/gamefirst.ogg")


func warningSound():
	AudioManager.playSound("res://Assets/Audio/SFX/warningSound.wav")


func gameoverMusic():
	AudioManager.playMusic("res://Assets/Prototype/Audio/gameovertheme.ogg",1)