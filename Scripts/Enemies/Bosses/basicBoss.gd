# basicBoss.gd
extends baseEnemy

# Variables
export(float) var moveSpeed
onready var projCreator = $projectileCreator
var moveDir: float = -1

func startAction():
	var shotType = customMethods.getWeightedRNG([40, 60])
	if shotType == 0:
		yield(get_tree().create_timer(1.25, false), "timeout")
		projCreator.angleShoot(0, 180, 5)
	else:
		yield(get_tree().create_timer(1, false), "timeout")
		var player = get_node("/root/Level/Player")
		if player:
			projCreator.targetShoot(1, player, 1)
		else:
			projCreator.angleShoot(1, 180, 1)
	startAction()

func _process(_delta):
	motion = Vector2(0, moveDir * moveSpeed)
	if position.y <= 80:
		moveDir = lerp(moveDir, 1, 0.25)
	if position.y >= 280:
		moveDir = lerp(moveDir, -1, 0.25)