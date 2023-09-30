# Player.gd
extends KinematicBody2D

# Variables
var health : int = 3
export var speed = 250
var motion : Vector2 = Vector2.ZERO
export var canControl : bool = false
var lerpValue : float = 20
onready var projectileCreator = $projectileCreator
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer

signal healthChange(value)
signal death()

func _ready():
	pass
	#canControl = false

func _process(_delta):
	if canControl:
		if Input.is_action_pressed("ui_accept"):
			shooting()

func _physics_process(delta):
	# Movement
	if canControl:
		var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		var input = Vector2(x_input, y_input).normalized()

		motion = motion.linear_interpolate(input, delta * lerpValue)
	
	move_and_slide(motion * speed)

func shooting():
	if shootTimer.is_stopped():
		projectileCreator.angleShoot(0)
		shootTimer.start()

func damage():
	if invisTimer.is_stopped():
		health -= 1
		emit_signal("healthChange", health)
		invisTimer.start()
		if health <= 0:
			emit_signal("death")
			queue_free()

func enableControl():
	canControl = true

func _on_DamageBox_area_entered(area):
	if area.is_in_group("enemy"):
		damage()
