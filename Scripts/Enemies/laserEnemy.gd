extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator: projectileCreator = $projectileCreator
onready var chargeParticles: CPUParticles2D = $ChargeParticles

func startAction():
	yield(get_tree().create_timer(0.5, false),"timeout")

	#Play charging animation
	chargeParticles.emitting = true
	yield(get_tree().create_timer(chargeParticles.lifetime, false),"timeout")

	#Constant shooting
	var shootBullets: int = 20
	while shootBullets:
		projCreator.angleShoot(0, 180)
		setBounce(0.8, 180)
		yield(get_tree().create_timer(0.1, false),"timeout")
		shootBullets -= 1

	startOutro()

func startOutro():
	var outroVector: Vector2 = Vector2(-forwardMotion, 0)
	if outroProperties != null:
		outroVector = outroProperties.direction * forwardMotion
	yield(get_tree().create_tween().tween_property(self, "motion", outroVector, 0.3), "finished")