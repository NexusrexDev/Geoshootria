# Spawner.gd
extends Node

### Variables
# Pattern variables
export(Array, Resource) var enemyPatterns
export(Array, Resource) var bossPatterns
export(Resource) var empoweringPattern
# Range variables for the enemy/boss percentages
export(int, 0, 100) var enemyRange
export(int, 0, 100) var bossRange
# SelectionRange's minimum and maximum ranges
export(Array, int) var selectionMinMax
# Enemy arrays
export(Array, PackedScene) var enemyReferences
# Inner spawner variables
var finishedPatterns: int
var currentPattern
var fullEnemies: int
var currentEnemy: int
var completedEnemies: int
var selectionRange: int
# References
onready var patternTimer = $patternTimer
onready var enemyTimer = $enemyTimer

func _ready():
	# This will be removed once an intro animation is made
	startSpawner()

func startSpawner():
	# Used to start the pattern, preferably using a signal after finishing the intro anim
	randomize()
	patternPicker()

func stopSpawner():
	# Used to stop the patterns by stopping all timers
	patternTimer.stop()
	enemyTimer.stop()

# This method starts the spawner by selecting a pattern
func patternPicker():
	# Sets the selection range to the fullest if the desired number of patterns is passed
	selectionRange = selectionMinMax[1] if (finishedPatterns > 5) else selectionMinMax[0]
	
	# Random number generation (from 0 to 100)
	# warning-ignore:narrowing_conversion
	var randomRangeNumber: int = (randf() * 100)
	
	# Selecting with ranges based on the player's progress
	if selectionRange == selectionMinMax[1]:
		if randomRangeNumber < enemyRange:
			# Enemy pattern selection
			var randomEnemyNumber: int = (randi() % selectionRange)
			currentPattern = enemyPatterns[randomEnemyNumber]
		elif randomRangeNumber < (enemyRange + bossRange):
			# Boss pattern selection
			var randomBossNumber: int = (randi() % 2)
			currentPattern = bossPatterns[randomBossNumber]
		else:
			# Empowering pattern selection
			currentPattern = empoweringPattern
	else:
		# Excluding the boss range value from the entire equation by extending the enemy range
		if randomRangeNumber < (enemyRange + bossRange):
			# Enemy pattern selection
			var randomEnemyNumber: int = (randi() % selectionRange)
			currentPattern = enemyPatterns[randomEnemyNumber]
		else:
			# Empowering pattern selection
			currentPattern = empoweringPattern
	
	# Setting the additional variables
	currentEnemy = 0
	completedEnemies = 0
	fullEnemies = currentPattern.enemyList.size()
	
	# Starting by creating an enemy
	createEnemy()

# This method creates an enemy, called in the start of a pattern, and when a timer is off
func createEnemy():
	# Variables to utilize for creating enemies
	var currentEnemyRef = currentPattern.enemyList[currentEnemy]
	var currentEnemyAtPlayer: bool = currentEnemyRef.createAtPlayer
	var currentEnemyType: int = currentEnemyRef.enemyType
	var currentEnemyPos: Vector2 = currentEnemyRef.enemyPosition
	var currentCreationProps = currentEnemyRef.creationProperties
	var currentTimeBreak = currentEnemyRef.timeBreak
	
	# Instantiating the enemy
	var enemy = enemyReferences[currentEnemyType].instance()
	if currentEnemyAtPlayer:
		var player = get_node("/root/Level/Player")
		enemy.position = Vector2(688,player.position.y)
	else:
		enemy.position = currentEnemyPos
	enemy.creationProperties = currentCreationProps
	get_parent().call_deferred("add_child", enemy)
	
	# Incrementing the currentEnemy variable and setting the timer
	currentEnemy += 1
	enemyTimer.wait_time = currentTimeBreak
	if currentEnemy != fullEnemies:
		enemyTimer.start()

# This method is called once an enemy is destroyed/passed safely (using a signal)
func enemyPassed():
	# Increment the completed enemy variable
	completedEnemies += 1
	
	# Check if all enemies are done, then restart by calling the reset timer
	if currentEnemy == completedEnemies && currentEnemy == fullEnemies:
		patternTimer.start()
