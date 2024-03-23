# Spawner.gd
class_name Spawner
extends Node

enum enemies {
	normal,
	shoot,
	homing,
	laser
}

### Variables
# Pattern variables
export(Array, Resource) var easyPatterns
# Enemy arrays
export(Array, PackedScene) var enemyReferences
# Inner spawner variables
var running: bool
var finishedPatterns: int
var currentPattern
var fullEnemies: int
var currentEnemy: int
var completedEnemies: int
var currentBoss: bool = false
var hasChunk: bool = false 
var chunkCount: int #Chunk ends when the completed enemies are equal to this
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
	var selectedPattern = easyPatterns[0]
	var isBoss = false

	# Pattern selection logic (based on the current level) goes here
	
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
	var currentIntroProps: Resource = currentEnemyRef.introProperties
	var currentActionProps: Resource = currentEnemyRef.actionProperties
	var currentOutroProps: Resource = currentEnemyRef.outroProperties
	var currentTimeBreak = currentEnemyRef.timeBreak
	hasChunk = currentEnemyRef.chunkEnd
	chunkCount = currentEnemy
	
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
	enemy.outroProperties = currentOutroProps
	get_parent().call_deferred("add_child", enemy)
	
	# Incrementing the currentEnemy variable and setting the timer
	currentEnemy += 1
	if currentEnemy != fullEnemies:
		if currentTimeBreak == 0:
			createEnemy()
		else:
			enemyTimer.wait_time = currentTimeBreak
			if !hasChunk:
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
		return

	if hasChunk && completedEnemies == chunkCount + 1:
		enemyTimer.start()

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
	stopSpawner()
	running = true
	startPattern(enemyPatterns[patternIndex], patternIndex == 3)
