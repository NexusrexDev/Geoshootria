# bombEnemy.gd
extends baseEnemy

# Variables
export var forwardMotion: float
onready var projCreator = $projectileCreator
onready var sprite = $Sprite
var sine: float

func startAction():
	motion = Vector2(-forwardMotion, 0)

func _process(delta):
	sine += delta * 2
	var verticalMotion = cos(sine) * 4 * (-1)
	sprite.position.y = -16 + verticalMotion

func death():
	projCreator.radialShoot(0, 0, 8)
	queue_free()
