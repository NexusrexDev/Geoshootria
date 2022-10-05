extends Label

func _process(_delta):
	if visible:
		text = "FPS: " + str(Engine.get_frames_per_second())
