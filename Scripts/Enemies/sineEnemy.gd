# sineEnemy.gd
extends baseEnemy

var sine = 0
var c = 180
export var speed = 60 # Multiply by -1 for downwards motion

func _process(delta):
	sine += c * delta
	motion.y = cos(deg2rad(sine)) * 2 * speed
