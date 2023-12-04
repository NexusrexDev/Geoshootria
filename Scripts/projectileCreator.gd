# projectileCreator.gd
class_name projectileCreator
extends Position2D

# Variables
export(Array, PackedScene) var projectileReferences
export(Array, AudioStreamSample) var audioReferences

func angleShoot(projectile: int, angle: float = 0, count: float = 1, offset: Vector2 = Vector2.ZERO):
	# Angular blasts create a 120 degree arc, using it as a reference to divide
	var arc = 45
	var creationAngle: float = angle - (arc/2)
	var incrementValue: float = arc / (count + 1)

	# Instantiating the projectile
	var level = get_tree().root.get_child(1)

	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position + offset
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)

	# Playing on shooting
	if audioReferences.size() > 0:
		AudioManager.playSound(audioReferences[projectile].resource_path)

func radialShoot(projectile: int, angle: float = 0, count: float = 1, offset: Vector2 = Vector2.ZERO):
	# Circular blasts start from *angle* degree, dividing the circle evenly
	var creationAngle: float = angle
	var incrementValue: float = 360 / count
	
	# Instantiating the projectile
	var level = get_tree().root.get_child(1)

	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position + offset
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)

	# Playing on shooting
	if audioReferences.size() > 0:
		AudioManager.playSound(audioReferences[projectile].resource_path)

func targetShoot(projectile: int, object: Node, count: float = 1, offset: Vector2 = Vector2.ZERO):
	# Find angle between the projectileCreator and the object
	assert(object, "No object was found")
	var creationAngle: float = Vector2(object.position.x - global_position.x,
		- ((object.position.y - 16) - global_position.y) ).angle()
	creationAngle = rad2deg(creationAngle)

	# Angular arc, in case of higher count of projectiles
	var arc = 45
	creationAngle = creationAngle - (arc/2)
	var incrementValue: float = arc / (count + 1)

	# Instantiating the projectile
	var level = get_tree().root.get_child(1)

	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position + offset
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)

	# Playing on shooting
	if audioReferences.size() > 0:
		AudioManager.playSound(audioReferences[projectile].resource_path)
