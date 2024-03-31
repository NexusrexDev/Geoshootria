# projectileCreator.gd
class_name projectileCreator
extends Position2D

# Variables
export(Array, PackedScene) var projectileReferences
export(Array, AudioStreamSample) var audioReferences

func angleShoot(projectile: int, angle: float = 0, count: int = 1, arc: float = 45, offset: Vector2 = Vector2.ZERO) -> void:
	var creationAngle: float = angle - (arc/2)
	var incrementValue: float = arc / (count + 1)

	# Instantiating the projectile
	var level: Node = get_tree().root.get_child(1)

	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position + offset
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)

	# Playing on shooting
	if audioReferences.size() > 0:
		AudioManager.playSound(audioReferences[projectile].resource_path)

func radialShoot(projectile: int, angle: float = 0, count: float = 1, offset: Vector2 = Vector2.ZERO) -> void:
	# Circular blasts start from *angle* degree, dividing the circle evenly
	var creationAngle: float = angle
	var incrementValue: float = 360 / count
	
	# Instantiating the projectile
	var root = get_tree().root
	var level = root.get_child(root.get_child_count() - 1)

	for i in range(count):
		var proj = projectileReferences[projectile].instance()
		proj.position = global_position + offset
		proj.angle = creationAngle + (incrementValue * (i + 1))
		level.call_deferred("add_child", proj)

	# Playing on shooting
	if audioReferences.size() > 0:
		AudioManager.playSound(audioReferences[projectile].resource_path)