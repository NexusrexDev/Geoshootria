# linearShootEnemy.gd
extends baseEnemy

# Variables
onready var shootTimer = $shootTimer
onready var shootPosition = $Position2D
export(PackedScene) var projectile
export(int) var shots

func shoot():
	for i in range(0, shots):
		var instance = projectile.instance()
		get_parent().call_deferred("add_child",instance)
		instance.position = shootPosition.global_position
		if shots > 1:
			instance.angle = 180 - (25 * (shots - 2) ) + (25 * i)
		else:
			instance.angle = 180
