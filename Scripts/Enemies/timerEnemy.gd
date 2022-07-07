# timerEnemy.gd => Used for the zigzag and big sine enemies
extends baseEnemy

# Variables
onready var tween = $Tween
onready var startTimer = $startTimer
onready var endTimer = $endTimer

export(Vector2) var firstMotion
export(Vector2) var secondMotion

func firstMotionStart():
	tween.interpolate_property(self,"motion",motion,firstMotion,0.2)
	tween.start()
	endTimer.start()

func secondMotionStart():
	tween.interpolate_property(self,"motion",motion,secondMotion,0.2)
	tween.start()
