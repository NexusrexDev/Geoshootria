extends baseEnemy

onready var projCreator = $projectileCreator
export var waitGap: float = 0.3

func startAction():
	for i in actionProperties.repositionPos.size():
		# Find new position
		var newPosition = position + actionProperties.repositionPos[i]
		var tweenTime: float = global_position.distance_to(newPosition) / 232
		yield(get_tree().create_tween().tween_property(self, "position", newPosition, tweenTime).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT), "finished")

		# Shoot if allowed
		if actionProperties.shootOnStop[i]:
			projCreator.angleShoot(0, 180)

		# Wait for gap time
		yield(get_tree().create_timer(waitGap, false), "timeout")

	
