# homingEnemy.gd
extends baseEnemy

func _ready():
	var player = get_parent().get_node("Player")
	if player == null:
		motion.x = -225
	else:
		var direction = (player.global_position - global_position).normalized()
		motion = direction * 225
