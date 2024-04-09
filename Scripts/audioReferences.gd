extends AnimationPlayer

# This holds methods to call when playing music for the gameplay/gameover situations
func mainMusic():
	AudioManager.playMusic("res://Assets/Audio/Music/stageTheme.ogg")


func stopMusic():
	AudioManager.stopMusic()


func warningSound():
	AudioManager.playSound("res://Assets/Audio/SFX/warningSound.wav")


func gameoverMusic():
	AudioManager.playMusic("res://Assets/Audio/Music/loseJingle.wav")