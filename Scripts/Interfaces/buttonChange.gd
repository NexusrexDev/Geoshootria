extends BaseButton

func _gui_input(event):
	if event.is_action_released("ui_select"):
		emit_signal("pressed")
