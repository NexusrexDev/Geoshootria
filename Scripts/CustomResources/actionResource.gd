# actionResource.gd
class_name actionResource
extends Resource

export(bool) var sinewave = false
export(bool) var canShoot = false

tool
func _init() -> void:
	resource_name = "Action properties"