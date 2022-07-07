# Spawner.gd
extends Node

# Variables
export(Array, Resource) var pattern
var currentPattern
var currentEnemy
var fullEnemies
var completedEnemy
onready var patternTimer = $patternTimer
onready var enemyTimer = $enemyTimer

var propExtra = [""]

func _ready():
	randomize()
	patternSelector()

func patternSelector():
	currentPattern = pattern[randi() % pattern.size()]
	currentEnemy = 0
	completedEnemy = 0
	fullEnemies = currentPattern.enemy.size()
	spawnEnemy()

func spawnEnemy():
	if currentEnemy < fullEnemies:
		# Create an instance
		var object = currentPattern.enemy[currentEnemy].type.instance()
		get_parent().call_deferred("add_child",object)
		object.global_position = currentPattern.enemy[currentEnemy].position
		enemyTimer.wait_time = currentPattern.enemy[currentEnemy].pauseTime
		enemyTimer.start()
		currentEnemy += 1

func enemyPassed():
	completedEnemy += 1
	# Start the pattern choosing process if all enemies have passed
	if currentEnemy == fullEnemies && completedEnemy == currentEnemy:
		patternTimer.start()
