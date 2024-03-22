# introResource.gd
class_name introResource
extends Resource

export var gotoPos: Vector2

tool
func _init() -> void:
	resource_name = "Intro position"
