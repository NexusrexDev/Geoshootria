extends Node

var player: AudioStreamPlayer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

	player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Music"

func stopPlayback():
	player.stop()

func playTrack(sound_path: String, fadein: int = 0):
	player.stream = load(sound_path)
	player.play()
	if fadein > 0:
		player.volume_db = -80
		var fadeTween = get_tree().create_tween()
		fadeTween.tween_property(player, "volume_db", 0.0, fadein)