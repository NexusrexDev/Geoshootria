# groundturretEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator = $projectileCreator

func startAction():
	motion = Vector2(-forwardMotion, 0)
	for _i in range(3):
		yield(get_tree().create_timer(2.13, false),"timeout")
		var player = get_node("/root/Level/Player")
		if player:
			projCreator.targetShoot(0, player)
		else:
			projCreator.angleShoot(0, 180)