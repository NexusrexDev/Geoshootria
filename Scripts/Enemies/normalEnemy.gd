# normalEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
export var canShoot: bool
onready var projCreator: projectileCreator = $projectileCreator
#Sinewave properties
var sineX: float = 0
var sineIncrement: float = 2.7
var verticalSpeed: float = 70
var sineDirection: int = -1

func startAction():
	if introType == intro.none:
		motion = Vector2(-forwardMotion, 0)
		return

	motion = Vector2(-64, 0)

	yieldTimer.start(1);yield(yieldTimer,"timeout")

	# Shooting, in variant mode
	if canShoot:
		var root = get_tree().root
		var currentScene = root.get_child(root.get_child_count() - 1)
		var player = currentScene.get_node("Player")
		var angle: float = 180
		if player:
			angle = rad2deg(get_angle_to(player.position))
		
		setBounce(1, angle)
		projCreator.angleShoot(0, angle)


	yieldTimer.start(0.2);yield(yieldTimer,"timeout")

	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")

func _process(delta):
	if actionProperties != null && actionProperties.sinewave:
		sineX += delta * sineIncrement
		var verticalMotion = cos(sineX) * verticalSpeed * (-sineDirection)
		motion.y = verticalMotion