# enemyResource.gd
class_name enemyResource
extends Resource

# Variables
export(Spawner.enemies) var enemyType setget setEnemyType
export(bool) var createAtPlayer = false
export(Vector2) var enemyPosition
export(Resource) var introProperties
export(Resource) var actionProperties
export(Resource) var outroProperties
export(bool) var chunkEnd = false
export(float, 0, 60) var timeBreak

tool
func _init() -> void:
	resource_name = str(Spawner.enemies.keys()[enemyType]).capitalize()

# This setget method is used to change the resource name based on the EnemyType
func setEnemyType(new_enemyType) -> void:
	enemyType = new_enemyType
	property_list_changed_notify()
	resource_name = str(Spawner.enemies.keys()[enemyType]).capitalize()
