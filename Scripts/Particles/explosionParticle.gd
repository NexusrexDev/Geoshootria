extends CPUParticles2D

func _ready():
	AudioManager.playSound("Assets/Audio/SFX/Enemy/enemyDeath.wav")
	emitting = true
	yield(get_tree().create_timer(0.5, false), "timeout")
	queue_free()