# dasherEnemy.gd
extends baseEnemy

# Variables
export var anticipateTime: float = 0.2
export var forwardMotion: float
export var isVariant: bool
onready var projCreator = $projectileCreator

func startAction():
	# Calling the base method to include the depth and collision setting
	.startAction()
	# Setting a coroutine with the tween to the anticipation value
	yield(get_tree().create_tween().tween_property(self, "motion", Vector2(120,0), anticipateTime), "finished")
	# Dashing forward afterwards
	motion = Vector2(-forwardMotion, 0)
	
	# Shooting, in variant mode
	if isVariant:
		yield(get_tree().create_timer(1, false), "timeout")
		var player = get_node("/root/Level/Player")
		if player:
			projCreator.targetShoot(0, player)
		else:
			projCreator.angleShoot(0, 180)
