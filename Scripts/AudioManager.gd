extends Node

var playersNum : int = 8
var bus : String = "SFX"

var musicPlayer: AudioStreamPlayer
var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var pitches = [] # The queue of pitches to set

func _ready():
    pause_mode = Node.PAUSE_MODE_PROCESS

    # SFX players pool
    for i in playersNum:
        var p = AudioStreamPlayer.new()
        add_child(p)
        available.append(p)
        p.connect("finished", self, "_on_stream_finished", [p])
        p.bus = bus

    musicPlayer = AudioStreamPlayer.new()
    add_child(musicPlayer)
    musicPlayer.bus = "Music"

func stopMusic():
    musicPlayer.stop()

func playMusic(sound_path: String, fadein: int = 0):
    musicPlayer.stream = load(sound_path)
    musicPlayer.play()
    if fadein > 0:
        musicPlayer.volume_db = -80
        var fadeTween = get_tree().create_tween()
        fadeTween.tween_property(musicPlayer, "volume_db", 0.0, fadein)

func playSound(sound_path, pitch:float = 1):
    queue.append(sound_path)
    pitches.append(pitch)

func _on_stream_finished(stream):
    # When finished playing a stream, make the player available again.
    available.append(stream)

func _process(_delta):
    # Play a queued sound if any players are available.
    if not queue.empty() and not available.empty():
        available[0].stream = load(queue.pop_front())
        available[0].pitch_scale = pitches[0]
        available[0].play()
        available.pop_front()
        pitches.pop_front()