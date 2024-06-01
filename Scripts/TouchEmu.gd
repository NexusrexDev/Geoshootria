extends Control

var touch: bool = false
var touchIndex: int = -1
var contRadius: float = 16
var start_pos: Vector2
var drag_pos: Vector2 = Vector2.ZERO
export(Texture) var joystickBase
export(Texture) var joystickTop

signal joystick_moved(pos)

func _ready():
	if visible:
		if OS.has_feature("Android") or OS.is_debug_build():
			set_process_input(true)
			set_process(true)
		else:
			set_process_input(false)
			set_process(false)
	else:
		set_process_input(false)
		set_process(false)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed: # Press
			if event.position.x < get_viewport_rect().size.x / 2:
				start_pos = event.position / 2
				touchIndex = event.index
				touch = true
			else:
				if event.index != touchIndex:
					Input.action_press("gp_shoot")
		else: # Release
			if event.index == touchIndex:
				drag_pos = Vector2.ZERO
				touch = false
				touchIndex = -1
			else:
				Input.action_release("gp_shoot")
	elif event is InputEventScreenDrag:
		if touch and event.index == touchIndex:
			drag_pos = (event.position/2) - start_pos
			drag_pos = clampController(drag_pos, contRadius)
	emit_signal("joystick_moved", customNormalize(drag_pos))
	update()

func clampController(vec: Vector2, radius: float) -> Vector2:
	var distance = vec.length()
	if distance < radius:
		return vec
	var scale = min(radius, distance) / distance
	return vec * scale

func customNormalize(vec: Vector2) -> Vector2:
	if vec.length() < (contRadius / 4):
		return Vector2.ZERO
	else:
		return vec / contRadius

func _draw():
	if touch:
		draw_texture(joystickBase, start_pos - Vector2(joystickBase.get_size().x / 2, joystickBase.get_size().y / 2))
		draw_texture(joystickTop, drag_pos + start_pos - Vector2(joystickTop.get_size().x / 2, joystickTop.get_size().y / 2))
