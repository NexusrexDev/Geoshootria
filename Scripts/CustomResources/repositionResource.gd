# respositionResource.gd
class_name respositionResource
extends Resource

export(Array, Vector2) var repositionPos
export(Array, bool) var shootOnStop

tool
func _init():
	resource_name = "Reposition properties"
