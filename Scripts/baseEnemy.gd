# baseEnemy.gd
extends Area2D
class_name baseEnemy

# Variables
export var health: int
var score: int
export var motion: Vector2
onready var invisTimer = $iframeTimer
var temp_motion: Vector2

signal death(score)
signal completed()

func _ready():
	# Connecting the score update signal to the HUD/Game Manager
	var HUD = get_node("/root/Level/HUD")
	connect("death", HUD, "scoreUpdate")
	# Connecting the death and safe passing/destruction to the spawner
	var Spawner = get_node("/root/Level/Spawner")
	connect("completed", Spawner, "enemyPassed")
	score = health * 5

func _process(delta):
	# Basic movement, use the inherited scripts to apply motion
	position += motion * delta

func damage(area):
	if invisTimer.is_stopped():
		health -= 1
		area.queue_free()
		invisTimer.start()
		# Knockback
		temp_motion = motion
		motion = Vector2(motion.x * 0.75, motion.y)
		position += Vector2(6, 0)
		if health <= 0:
			#Should include death effects and death signal to the spawner
			emit_signal("death", score)
			emit_signal("completed")
			queue_free()

func _on_Enemy_area_entered(area):
	if area.is_in_group("playerProj"):
		damage(area)
			
	if area.is_in_group("enemyLimit"):
		emit_signal("completed")
		queue_free()


func invisOver():
	motion = temp_motion
