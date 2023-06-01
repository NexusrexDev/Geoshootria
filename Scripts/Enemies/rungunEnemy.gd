# rungunEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: Vector2
onready var projectileCreator = $projectileCreator

func startAction():
	# Step 1: wait
	yield(get_tree().create_timer(0.2, false), "timeout")
	# Step 2: shoot, then start moving to the position below/above
	var player = get_node("/root/Level/Player")
	if player:
		projectileCreator.shoot(0, projectileCreator.AT_OBJECT, 1, 0, player)
	else:
		projectileCreator.shoot(0, projectileCreator.ANGLE, 1, 0)
	yield(get_tree().create_timer(0.25, false), "timeout")
	var gotoRun: Vector2 = Vector2(position.x, position.y + (148 * creationProperties.dir) )
	var tempTween = get_tree().create_tween()
	yield(tempTween.tween_property(self, "position", gotoRun, 1), "finished")
	# Step 3: shoot again, then run forward
	if player:
		projectileCreator.shoot(0, projectileCreator.AT_OBJECT, 1, 0, player)
	else:
		projectileCreator.shoot(0, projectileCreator.ANGLE, 1, 0)
	tempTween = get_tree().create_tween()
	tempTween.tween_property(self, "motion", forwardMotion, 0.2)
