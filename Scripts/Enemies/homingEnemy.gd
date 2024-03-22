# homingEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
export var isVariant: bool
onready var projCreator = $projectileCreator

func startAction():
	# Finding the player and moving towards the object
	var player = get_node("/root/Level/Player")
	var homingAngle: float = Vector2(player.position.x - global_position.x,
		- ((player.position.y) - global_position.y) ).angle()

	motion = Vector2(cos(homingAngle) * forwardMotion, -sin(homingAngle) * forwardMotion)
	
	rotation_degrees = rad2deg(-homingAngle)
	

	# Shooting, in variant mode
	if isVariant:
		yield(get_tree().create_timer(1, false), "timeout")
		player = get_node("/root/Level/Player")
		if player:
			projCreator.targetShoot(0, player)
		else:
			projCreator.angleShoot(0, 180)
