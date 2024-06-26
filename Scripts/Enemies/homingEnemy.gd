# homingEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float

func startAction():
	# Finding the player and moving towards the object
	var player = currentScene.get_node("Player")
	var homingAngle: float = Vector2(player.position.x - global_position.x,
		- ((player.position.y) - global_position.y) ).angle()

	motion = Vector2(cos(homingAngle) * forwardMotion, -sin(homingAngle) * forwardMotion)
	
	rotation_degrees = rad2deg(-homingAngle)
