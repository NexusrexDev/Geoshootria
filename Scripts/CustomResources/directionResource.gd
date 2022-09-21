# sineResource.gd
class_name directionResource
extends Resource

export(int, -1, 1, 2) var dir = 1

tool
func _init():
	resource_name = "Direction"
