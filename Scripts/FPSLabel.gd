extends Label

func _process(delta):
	if visible:
		text = "FPS: " + str(Engine.get_frames_per_second())
