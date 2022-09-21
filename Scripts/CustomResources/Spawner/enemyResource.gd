# enemyResource.gd
class_name enemyResource
extends Resource

enum enemies {
	normal,
	sinewave,
	run_and_gun,
	charger,
	dasher,
	normal_aim,
	zigzag,
	bomb,
	boss1,
	boss2
}

# Variables
export(enemies) var enemyType setget setEnemyType
export(bool) var createAtPlayer
export(Vector2) var enemyPosition
export(Resource) var creationProperties
export(float, 0.05, 60) var timeBreak

tool
func _init():
	resource_name = str(enemies.keys()[enemyType]).capitalize()

# This setget method is used to change the resource name based on the EnemyType
func setEnemyType(new_enemyType):
	enemyType = new_enemyType
	property_list_changed_notify()
	resource_name = str(enemies.keys()[enemyType]).capitalize()
