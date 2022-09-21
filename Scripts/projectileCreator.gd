# projectileCreator.gd
class_name projectileCreator
extends Position2D

# Variables
enum {
	ANGLE,
	CIRCULAR,
	AT_OBJECT
}
export(Array,PackedScene) var projectileReferences

func shoot(projectile: int, aimType, count: float, angle: float = 0, object: Node = null):
	var creationAngle: float
	var incrementValue: float
	if aimType == AT_OBJECT:
		# Find angle between the projectileCreator and the object
		assert(object, "No object was found")
		angle = Vector2(object.position.x - global_position.x,
			- ((object.position.y - 16) - global_position.y) ).angle()
		angle = rad2deg(angle)
	if aimType == CIRCULAR:
		# Circular blasts start from 0 degree, dividing the circle evenly
		creationAngle = angle
		incrementValue = 360 / count
	else:
		# Angular blasts create a 120 degree arc, using it as a reference to divide
		var arc = 45
		creationAngle = angle - (arc/2)
		incrementValue = arc / (count + 1)
	# Instantiating the projectile
	var level = get_tree().root.get_child(0)
	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)
