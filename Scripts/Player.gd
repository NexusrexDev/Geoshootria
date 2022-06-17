# Player.gd
extends KinematicBody2D

# Variables
export var speed = 200
var motion = Vector2.ZERO
onready var shootingPos = $Position2D
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer

# Constants
const projectile = preload("res://Scenes/Projectile.tscn")

func _process(delta):
	shooting()

func _physics_process(delta):
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
