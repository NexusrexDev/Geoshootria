extends Camera2D

var shakeVal: float = 0
var shakeDecay: float = 8

func _ready():
	GameManager.connect("cameraShake", self, "setShake")

func setShake(value: float):
	shakeVal = value

func _process(delta):
	if shakeVal:
		shakeVal = max(0, shakeVal - delta * 0.8)
		shake()

func shake():
	# Randomly shaking the enemy
	var shakeX = rand_range(-shakeVal, shakeVal) * 8
	var shakeY = rand_range(-shakeVal, shakeVal) * 8
	position = Vector2(shakeX, shakeY)