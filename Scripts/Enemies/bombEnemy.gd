# bomEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
onready var projectileCreator = $projectileCreator

func startAction():
	motion = forwardMotion

func death():
	projectileCreator.shoot(0, projectileCreator.CIRCULAR, 8)
	queue_free()
