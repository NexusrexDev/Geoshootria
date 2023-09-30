# baseProjectile.gd
extends Area2D

# Variables
export var angle = 0
export var speed = 600
var motion = Vector2.ZERO

func _ready():
	var c_angle = (angle*PI) / 180
	motion = Vector2(cos(c_angle),-sin(c_angle))

func _process(delta):
	position += motion * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area_entered(area:Area2D):
	if area.is_in_group("projLimit") and self.is_in_group("playerProj"):
		queue_free()
