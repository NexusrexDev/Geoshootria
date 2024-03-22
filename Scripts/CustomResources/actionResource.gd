# actionResource.gd
class_name actionResource
extends Resource

enum action {
    SINEWAVE,
    SHOOTING
}

export(Array, action) var actions

tool
func _init() -> void:
	resource_name = "Action properties"