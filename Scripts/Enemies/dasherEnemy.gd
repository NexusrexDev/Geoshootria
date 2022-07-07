# dasherEnemy.gd
extends baseEnemy

# Variables
onready var collider = $CollisionShape2D
onready var dashTimer = $dashTimer
onready var tween = $Tween
onready var sprite = $Sprite

export(Array, Vector2) var motions

func _ready():
	sprite.scale = Vector2(4,4)
	collider.disabled = true
	motion = motions[0]

func returnMotion():
	tween.interpolate_property(self,"motion",motion,motions[1],0.2)
	tween.interpolate_property(sprite,"scale",sprite.scale,Vector2(1,1),dashTimer.wait_time)
	tween.start()
	dashTimer.start()

func dashMotion():
	tween.interpolate_property(self,"motion",motion,motions[2],0.2)
	collider.disabled = false
	tween.start()
