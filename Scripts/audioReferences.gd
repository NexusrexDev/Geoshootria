extends AnimationPlayer

# This holds methods to call when playing music for the gameplay/gameover situations
func mainMusic():
	MusicManager.playTrack("res://Assets/Prototype/Audio/gamefirst.ogg")

func gameoverMusic():
	MusicManager.playTrack("res://Assets/Prototype/Audio/gameovertheme.ogg",1)