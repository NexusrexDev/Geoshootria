extends Label

func _ready():
	if OS.has_feature("Android") or OS.is_debug_build():
		visible = true
	else:
		visible = false

func _process(_delta):
	if visible:
		text = "FPS: " + str(Engine.get_frames_per_second())
