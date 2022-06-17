# baseProjectile.gd
extends Area2D

# Variables
export var angle = 0
export var speed = 400
var motion = Vector2.ZERO

func _ready():
	var c_angle = (angle*PI) / 180
	motion = Vector2(cos(c_angle),-sin(c_angle))
	pass

func _process(delta):
	position += motion * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
