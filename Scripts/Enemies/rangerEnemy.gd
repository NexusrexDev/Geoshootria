# rangerEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator = $projectileCreator

func startAction():
	yield(get_tree().create_timer(0.25, false),"timeout")
	projCreator.angleShoot(0, 180)
	yield(get_tree().create_timer(0.25, false),"timeout")
	motion = Vector2(-forwardMotion, 0)