# rungunResource.gd
class_name rungunResource
extends Resource

export var gotoPos: Vector2
export(int, -1, 1, 2) var dir = 1

tool
func _init():
	resource_name = "Run and Gun properties"
