# sprayEnemy.gd
extends baseEnemy

# Variables
export var incrValue: float = 15
export var forwardMotion: float
onready var projCreator: projectileCreator = $projectileCreator

func startAction():
	yield(get_tree().create_timer(0.5, false),"timeout")

	var root = get_tree().root
	var currentScene = root.get_child(root.get_child_count() - 1)
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
		yield(get_tree().create_timer(0.1, false),"timeout")
		angle += (incrValue * direction)

	yield(get_tree().create_timer(0.2, false),"timeout")

	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")