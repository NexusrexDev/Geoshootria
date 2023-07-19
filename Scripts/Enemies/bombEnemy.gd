# bomEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
onready var projectileCreator = $projectileCreator

func startAction():
	motion = forwardMotion

func death():
	projectileCreator.radialShoot(0, 0, 8)
	queue_free()
