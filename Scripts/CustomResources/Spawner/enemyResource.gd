# enemyResource.gd
class_name enemyResource
extends Resource

enum enemies {
	normal,
	normal_var,
	ground_turret,
	ranger,
	sinewave,
	sinewave_var,
	dash,
	dash_var,
	homing,
	homing_var,
	bomb,
	spray,
	mega_spray,
	mini_wizard,
	wizard,
	basic_boss
}

# Variables
export(enemies) var enemyType setget setEnemyType
export(bool) var createAtPlayer
export(Vector2) var enemyPosition
export(Resource) var introProperties
export(Resource) var actionProperties
export(float, 0, 60) var timeBreak

tool
func _init():
	resource_name = str(enemies.keys()[enemyType]).capitalize()

# This setget method is used to change the resource name based on the EnemyType
func setEnemyType(new_enemyType):
	enemyType = new_enemyType
	property_list_changed_notify()
	resource_name = str(enemies.keys()[enemyType]).capitalize()
