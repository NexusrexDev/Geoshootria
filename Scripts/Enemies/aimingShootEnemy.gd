# aimingShootEnemy.gd
extends baseEnemy

# Variables
onready var shootTimer = $shootTimer
onready var shootPosition = $Position2D
export(PackedScene) var projectile

func shoot():
	var instance = projectile.instance()
	get_parent().call_deferred("add_child",instance)
	instance.position = shootPosition.global_position
	
	# Get the angle between the enemy and the player
	var player = get_parent().get_node("Player")
	if player == null:
		instance.angle = 180
	else:
		var diffVector = Vector2(
			player.global_position.x - shootPosition.global_position.x,
			(player.global_position.y - 16) - shootPosition.global_position.y
			)
		var direction = atan2(-diffVector.y, diffVector.x)
		direction = rad2deg(direction)
		instance.angle = direction
