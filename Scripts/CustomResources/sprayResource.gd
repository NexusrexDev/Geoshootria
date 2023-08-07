# sprayResource.gd
class_name sprayResource
extends Resource

export(float) var angle = 180.0
export(int) var count = 1
export(int, -1, 1, 2) var dir = 1

tool
func _init():
	resource_name = "Spray properties"
