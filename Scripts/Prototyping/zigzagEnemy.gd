# zigzagEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
export(Array, float) var timerValues
var zigzagDirection: int
onready var projectileCreator = $projectileCreator

func startAction():
	zigzagDirection = actionProperties.dir
	motion = forwardMotion
	yield(get_tree().create_timer(timerValues[0], false),"timeout")
	var tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",Vector2(-forwardMotion.x * 0.5,128 * zigzagDirection), 0.2)
	yield(get_tree().create_timer(timerValues[1], false),"timeout")
	# Shooting
	var player = get_node("/root/Level/Player")
	if player:
		projectileCreator.targetShoot(0, player)
	else:
		projectileCreator.angleShoot(0, 180)
	# Going forwards again
	tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",forwardMotion,0.2)
