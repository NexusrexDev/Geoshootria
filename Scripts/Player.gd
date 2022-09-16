# Player.gd
extends KinematicBody2D

# Variables
var health = 3
export var speed = 200
var motion = Vector2.ZERO
onready var shootingPos = $Position2D
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer

signal healthChange(value)
signal death()

# Packed scenes
export(PackedScene) var projectile
export(PackedScene) var debugEnemy
export(Vector2) var debugVector

func _process(_delta):
	shooting()
	
	#Temporary stuff
	if Input.is_action_just_released("ui_customspawn"):
		assert(debugEnemy, "No debug enemies were found")
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
		motion.x = lerp(motion.x, 0, .2)
	
	if y_input != 0:
		motion.y = lerp(motion.y, y_input, .25)
	else:
		motion.y = lerp(motion.y, 0, .2)
	
	move_and_slide(motion * speed)

func shooting():
	if Input.is_action_pressed("ui_accept"):
		if shootTimer.is_stopped():
			var shot = projectile.instance()
			get_parent().add_child(shot)
			shot.position = shootingPos.global_position
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
