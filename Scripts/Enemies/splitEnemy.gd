extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator: projectileCreator = $projectileCreator

func startAction():
	yield(get_tree().create_timer(0.5, false),"timeout")

	var player: Node = get_node("/root/Level/Player")
	var angle: float = 180
	if player:
		angle = rad2deg(get_angle_to(player.position))
		
	setBounce(1, angle)
	projCreator.angleShoot(0, angle, 3)

	yield(get_tree().create_timer(0.2, false),"timeout")

	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")