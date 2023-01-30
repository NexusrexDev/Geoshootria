# Player.gd
extends KinematicBody2D

# Variables
var health = 3
export var speed = 200
var motion = Vector2.ZERO
onready var projectileCreator = $projectileCreator
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer

signal healthChange(value)
signal death()

# Packed scenes
export(PackedScene) var debugEnemy
export(Vector2) var debugVector

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		shooting()
	
	#Temporary stuff
	if Input.is_action_just_released("ui_customspawn"):
		assert(debugEnemy, "No debug objects were found")
		var enemy = debugEnemy.instance()
		enemy.position = debugVector
		get_parent().add_child(enemy)

func _physics_process(_delta):
	# Movement
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if x_input != 0:
		motion.x = lerp(motion.x, x_input, .25)
	else:
		motion.x = lerp(motion.x, 0, .25)
	
	if y_input != 0:
		motion.y = lerp(motion.y, y_input, .25)
	else:
		motion.y = lerp(motion.y, 0, .25)
	
	move_and_slide(motion * speed)

func shooting():
	if shootTimer.is_stopped():
		projectileCreator.shoot(0, projectileCreator.ANGLE, 1, 0)
		shootTimer.start()

func damage():
	if invisTimer.is_stopped():
		health -= 1
		emit_signal("healthChange", health)
		invisTimer.start()
		if health <= 0:
			emit_signal("death")
			queue_free()

func _on_DamageBox_area_entered(area):
	if area.is_in_group("enemy"):
		damage()
