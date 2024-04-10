extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator: projectileCreator = $projectileCreator

func startAction():
	yieldTimer.start(0.5);yield(yieldTimer,"timeout")

	var player = currentScene.get_node("Player")
	var angle: float = 180
	if player:
		angle = rad2deg(get_angle_to(player.position))
		
	setBounce(1, angle)
	projCreator.angleShoot(0, angle, 3)

	yieldTimer.start(0.2);yield(yieldTimer,"timeout")

	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")