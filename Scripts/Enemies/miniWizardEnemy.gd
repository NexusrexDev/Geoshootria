# miniWizardEnemy.gd
extends baseEnemy

# Variables
export(PackedScene) var disappearAnim
onready var projCreator = $projectileCreator

func startAction():
	yield(get_tree().create_timer(0.4, false), "timeout")

	var player = get_node("/root/Level/Player")
	if player:
		projCreator.targetShoot(0, player)
	else:
		projCreator.angleShoot(0, 180)

	yield(get_tree().create_timer(1, false), "timeout")
	
	if disappearAnim != null:
		var anim = disappearAnim.instance()
		anim.position = Vector2(global_position.x, global_position.y - 16)
		get_parent().call_deferred("add_child", anim)

	emit_signal("completed")
	queue_free()
