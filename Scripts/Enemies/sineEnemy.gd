# sineEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
export var verticalSpeed: int
export var sineIncrement: int
var sineDirection: int
var sineX: float

func startAction():
	sineDirection = creationProperties.dir
	motion = forwardMotion

func _process(delta):
	sineX += delta * sineIncrement
	var verticalMotion = cos(sineX) * verticalSpeed * (-sineDirection)
	motion.y = verticalMotion
