# aimEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
export var shotCount: int
onready var projectileCreator = $projectileCreator

func startAction():
	motion = forwardMotion
	shooting()

func shooting():
	yield(get_tree().create_timer(0.5, false),"timeout")
	var player = get_node("/root/Level/Player")
	if player:
		projectileCreator.shoot(0, projectileCreator.AT_OBJECT, 1, 0, player)
	else:
		projectileCreator.shoot(0, projectileCreator.ANGLE, 1, 180)
	shotCount -= 1
	if shotCount > 0:
		shooting()
