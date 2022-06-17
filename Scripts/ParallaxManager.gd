# ParallaxManager.gd
extends ParallaxBackground

# Variables
export var speed = 10
onready var layers = [$FarTree,$CloseTree,$Bush,$Ground]

func _process(delta):
	layers[0].motion_offset.x -= 2 * speed * delta
	layers[1].motion_offset.x -= 4.5 * speed * delta
	layers[2].motion_offset.x -= 6 * speed * delta
	layers[3].motion_offset.x -= 6 * speed * delta
