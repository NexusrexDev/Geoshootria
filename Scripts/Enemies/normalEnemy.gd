# normalEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2

func startAction():
	motion = forwardMotion
