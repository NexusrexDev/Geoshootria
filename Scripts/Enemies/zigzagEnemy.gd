# zigzagEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
export(Array, float) var timerValues
var zigzagDirection: int

func startAction():
	zigzagDirection = creationProperties.dir
	motion = forwardMotion
	yield(get_tree().create_timer(timerValues[0]),"timeout")
	var tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",Vector2(-forwardMotion.x * 0.5,128 * zigzagDirection),0.2)
	yield(get_tree().create_timer(timerValues[1]),"timeout")
	tempTween = get_tree().create_tween()
	tempTween.tween_property(self,"motion",forwardMotion,0.2)
	# Code to shoot when moving forwards goes here
