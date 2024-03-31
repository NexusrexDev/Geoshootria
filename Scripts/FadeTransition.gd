extends ColorRect
class_name FadeTransition

enum fadeType {
	FADE_IN,
	FADE_OUT
}

export(fadeType) var fade_mode
export(String) var targetScene

func _ready():
	visible = true
	match fade_mode:
		fadeType.FADE_IN:
			color.a = 1
			yield(get_tree().create_tween().tween_property(self, "color:a", 0.0, 0.5), "finished")

		fadeType.FADE_OUT:
			color.a = 0
			yield(get_tree().create_tween().tween_property(self, "color:a", 1.0, 0.3), "finished")
			yield(get_tree().create_timer(0.1), "timeout")
			get_tree().change_scene(targetScene)
