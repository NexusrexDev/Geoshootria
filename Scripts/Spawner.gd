# Spawner.gd
extends Node

### Variables
# Pattern variables
export(Array, Resource) var easyPatterns
export(Array, Resource) var diffPatterns
export(Array, Resource) var bossPatterns
export(Resource) var empoweringPattern
export(int) var bossThreshold
# Enemy arrays
export(Array, PackedScene) var enemyReferences
# Inner spawner variables
var running: bool
var finishedPatterns: int
var currentPattern
var fullEnemies: int
var currentEnemy: int
var completedEnemies: int
var selectionRange: int
var currentBoss: bool = false
# References
onready var patternTimer = $patternTimer
onready var enemyTimer = $enemyTimer
onready var debugInterface = $CanvasLayer/DebugInterface

func _ready():
	$CanvasLayer/DebugInterface/ColorRect/PlayStop/StopResume.connect("pressed", self, "debugSpawnerControl")
	$CanvasLayer/DebugInterface/ColorRect/SelectPattern/PatternPlay.connect("pressed", self, "debugPatternPlay")

func startSpawner():
	# Used to start the pattern, using an AnimationPlayer
	running = true
	patternPicker()

func stopSpawner():
	# Used to stop the patterns by stopping all timers
	running = false
	patternTimer.stop()
	enemyTimer.stop()

# This method starts the spawner by selecting a pattern
func patternPicker():
	var selectedPattern
	var isBoss = false

	if finishedPatterns < bossThreshold:
		# Create a normal pattern or an empowering pattern, higher prob. to easy patterns
		var typeSelect = customMethods.getWeightedRNG([90, 10])
		if typeSelect == 0:
			var difficultySelect = customMethods.getWeightedRNG([100, 0])
			if difficultySelect == 0:
				selectedPattern = easyPatterns[randi() % easyPatterns.size()]
			else:
				selectedPattern = diffPatterns[randi() % diffPatterns.size()]
		else:
			selectedPattern = empoweringPattern

	elif finishedPatterns == bossThreshold:
		# Create the first boss and only the first boss
		isBoss = true
		selectedPattern = bossPatterns[0]

	elif finishedPatterns % bossThreshold == 0:
		# Create a normal pattern, a boss or an empowering pattern
		var typeSelect = customMethods.getWeightedRNG([63, 27, 10])
		if typeSelect == 0:
			var difficultySelect = customMethods.getWeightedRNG([50, 50])
			if difficultySelect == 0:
				selectedPattern = easyPatterns[randi() % easyPatterns.size()]
			else:
				selectedPattern = diffPatterns[randi() % diffPatterns.size()]
		elif typeSelect == 1:
			# Boss selection
			isBoss = true
			selectedPattern = bossPatterns[randi() % bossPatterns.size()]
		else:
			selectedPattern = empoweringPattern

	else:
		# Create a normal pattern or an empowering pattern, equal prob. to easy patterns
		var typeSelect = customMethods.getWeightedRNG([85, 15])
		if typeSelect == 0:
			var difficultySelect = customMethods.getWeightedRNG([50, 50])
			if difficultySelect == 0:
				selectedPattern = easyPatterns[randi() % easyPatterns.size()]
			else:
				selectedPattern = diffPatterns[randi() % diffPatterns.size()]
		else:
			selectedPattern = empoweringPattern
	
	startPattern(selectedPattern, isBoss)

# This method starts a pattern, used for debugging and separating the creation from the pattern selection
func startPattern(patternRes, isBoss: bool):
	currentPattern = patternRes

	# Setting the counters/pointers
	currentEnemy = 0
	completedEnemies = 0
	fullEnemies = currentPattern.enemyList.size()

	# Starting by creating an enemy, or a boss
	currentBoss = isBoss
	
	if fullEnemies != 0:
		createEnemy()

# This method creates an enemy, called in the start of a pattern, and when a timer is off
func createEnemy():
	if !running:
		return
	
	# Boss flourish goes here (Music change, warning message..etc)
	if currentBoss:
		pass
	
	# Variables to utilize for creating enemies
	var currentEnemyRef = currentPattern.enemyList[currentEnemy]
	var currentEnemyAtPlayer: bool = currentEnemyRef.createAtPlayer
	var currentEnemyType: int = currentEnemyRef.enemyType
	var currentEnemyPos: Vector2 = currentEnemyRef.enemyPosition
	var currentIntroProps = currentEnemyRef.introProperties
	var currentActionProps = currentEnemyRef.actionProperties
	var currentTimeBreak = currentEnemyRef.timeBreak
	
	# Instantiating the enemy
	var enemy = enemyReferences[currentEnemyType].instance()
	if currentEnemyAtPlayer:
		var player = get_node("/root/Level/Player")
		if player:
			enemy.position = Vector2(688, player.position.y)
		else:
			enemy.position = Vector2(688, 168)
	else:
		enemy.position = currentEnemyPos
	enemy.introProperties = currentIntroProps
	enemy.actionProperties = currentActionProps
	get_parent().call_deferred("add_child", enemy)
	
	# Incrementing the currentEnemy variable and setting the timer
	currentEnemy += 1
	if currentEnemy != fullEnemies:
		if currentTimeBreak == 0:
			createEnemy()
		else:
			enemyTimer.wait_time = currentTimeBreak
			enemyTimer.start()

# This method is called once an enemy is destroyed/passed safely (using a signal)
func enemyPassed():
	if !running:
		return
	# Increment the completed enemy variable
	completedEnemies += 1
	
	# Check if all enemies are done, then restart by calling the reset timer
	if currentEnemy == completedEnemies && currentEnemy == fullEnemies:
		patternTimer.start()
		# Adding up to the finished patterns counter to increase the range
		finishedPatterns += 1
		# If this was a boss pattern, stop music, change state
		if currentBoss:
			currentBoss = false

# Turning the debug menu on and off
func _process(_delta):
	if Input.is_action_just_released("ui_customspawn"):
		debugInterface.visible = !debugInterface.visible

# Starts/Stops the regular spawning behavior
func debugSpawnerControl():
	if running:
		stopSpawner()
	else:
		startSpawner()

# Plays a chosen pattern
func debugPatternPlay():
	# Temporarily stopped
	var patternIndex: int = $CanvasLayer/DebugInterface/ColorRect/SelectPattern/PatternIndex.get_selected_id()
	var enemyPatterns: Array = []
	enemyPatterns.append_array(easyPatterns)
	enemyPatterns.append_array(diffPatterns)
	enemyPatterns.append_array(bossPatterns)
	enemyPatterns.append(empoweringPattern)
	stopSpawner()
	running = true
	startPattern(enemyPatterns[patternIndex], patternIndex == 3)
