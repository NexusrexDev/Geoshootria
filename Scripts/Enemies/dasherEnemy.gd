# dasherEnemy.gd
extends baseEnemy

# Variables
export var anticipateTime: float
export var forwardMotion: Vector2

func startAction():
	# Calling the base method to include the depth and collision setting
	.startAction()
	# Setting a coroutine with the tween to the anticipation value
	yield(get_tree().create_tween().tween_property(self, "motion", Vector2(120,0), anticipateTime), "finished")
	# Dashing forward afterwards
	motion = forwardMotion
