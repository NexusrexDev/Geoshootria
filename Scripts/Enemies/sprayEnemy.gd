# sprayEnemy.gd
extends baseEnemy

# Variables
export var incrValue: float = 15
export var forwardMotion: float
onready var projCreator: projectileCreator = $projectileCreator

func startAction():
	yieldTimer.start(0.5);yield(yieldTimer,"timeout")

	var player = currentScene.get_node("Player")
	var angle: float = 180 - incrValue
	var direction: int = 1

	if player:
		if player.position.y > position.y:
			direction = -1
		angle = rad2deg(get_angle_to(player.position)) - (incrValue * direction)
	
	for _i in range(3):
		projCreator.angleShoot(0, angle)
		setBounce(1, angle)
		yieldTimer.start(0.1);yield(yieldTimer,"timeout")
		angle += (incrValue * direction)

	yieldTimer.start(0.2);yield(yieldTimer,"timeout")
	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")