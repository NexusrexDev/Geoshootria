# sineEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
export var verticalSpeed: int
export var sineIncrement: int
export var isVariant: bool
onready var projCreator = $projectileCreator
var sineDirection: int
var sineX: float

func startAction():
	sineDirection = actionProperties.dir
	motion = Vector2(-forwardMotion, 0)

	# Shooting, in variant mode
	if isVariant:
		yield(get_tree().create_timer(2, false),"timeout")
		var player = get_node("/root/Level/Player")
		if player:
			projCreator.targetShoot(0, player)
		else:
			projCreator.angleShoot(0, 180)

func _process(delta):
	sineX += delta * sineIncrement
	var verticalMotion = cos(sineX) * verticalSpeed * (-sineDirection)
	motion.y = verticalMotion
