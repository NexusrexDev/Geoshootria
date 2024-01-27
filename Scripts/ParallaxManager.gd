# ParallaxManager.gd
extends ParallaxBackground

# Variables
export var speed = 10
onready var layers = [$FarTree,$CloseTree,$Ground]

func _process(delta):
	layers[0].motion_offset.x -= 2 * speed * delta #Back Tree
	layers[1].motion_offset.x -= 4.5 * speed * delta #Front Tree
	layers[2].motion_offset.x -= 6 * speed * delta #Ground
