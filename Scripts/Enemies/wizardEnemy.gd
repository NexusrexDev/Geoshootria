# wizardEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator = $projectileCreator

func startAction():
	yield(get_tree().create_timer(0.4, false), "timeout")
	
	var player = get_node("/root/Level/Player")
	if player:
		projCreator.targetShoot(0, player, 3)
	else:
		projCreator.angleShoot(0, 180, 3)
	
	yield(get_tree().create_timer(0.3, false), "timeout")

	# Zig-zag motion
	var zigzagDirection = actionProperties.dir
	motion = Vector2(-forwardMotion, 0)

	yield(get_tree().create_timer(1, false),"timeout")
	var tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",Vector2(forwardMotion * 0.5, 128 * zigzagDirection), 0.2)
	yield(get_tree().create_timer(0.8, false),"timeout")
	tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",Vector2(-forwardMotion, 0), 0.2)