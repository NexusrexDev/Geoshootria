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

	yield(get_tree().create_timer(1, false),"timeout")

	# Shooting, in variant mode
	if canShoot:
		var player: Node = get_node("/root/Level/Player")
		var angle: float = 180
		if player:
			angle = rad2deg(get_angle_to(player.position))
		
		setBounce(1, angle)
		projCreator.angleShoot(0, angle)


	yield(get_tree().create_timer(0.2, false),"timeout")

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