# megaSprayEnemy.gd
extends baseEnemy

# Variables
export var incrValue: float = 10
export var forwardMotion: float
onready var projCreator = $projectileCreator

func startAction():
	.startAction()

	var shootAngle = actionProperties.angle
	var sprayDir = actionProperties.dir
	var shotCount = actionProperties.count
	var currentAngle = shootAngle - (int(shotCount / 2) * incrValue * sprayDir)
	
	yield(get_tree().create_timer(0.15, false), "timeout")

	for _i in range(shotCount):
		projCreator.angleShoot(0, currentAngle)
		currentAngle += (incrValue * sprayDir)
		yield(get_tree().create_timer(0.05, false), "timeout")
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	currentAngle -= ((incrValue + incrValue/2) * sprayDir)
	for _i in range(shotCount - 1):
		projCreator.angleShoot(0, currentAngle)
		currentAngle -= (incrValue * sprayDir)
		yield(get_tree().create_timer(0.05, false), "timeout")
	
	yield(get_tree().create_timer(0.25, false), "timeout")
	motion = Vector2(-forwardMotion, 0)