# Player.gd
extends KinematicBody2D

# Variable
var health : int = 3
export var speed : int = 240
export var focusSpeed : int = 120
var isFocus : bool = false
var motion : Vector2 = Vector2.ZERO
export var canControl : bool = false
var lerpValue : float = 20
var grazeValue : int = 5
onready var projectileCreator = $projectileCreator
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer

signal healthChange(value)
signal graze(score)
signal death()

func _ready():
	# Connecting the score update signal to the HUD/Game Manager
	var HUD = get_node("/root/Level/HUD")
	if HUD != null:
		connect("graze", HUD, "scoreUpdate")

func _process(_delta):
	if canControl:
		if Input.is_action_pressed("gp_shoot"):
			shooting()
		elif Input.is_action_just_released("gp_shoot"):
			shootTimer.stop()

func _physics_process(_delta):
	# Movement
	if canControl:
		var x_input : float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var y_input : float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		var input : Vector2 = Vector2(x_input, y_input).normalized()
		isFocus = Input.get_action_strength("gp_focus")

		motion = input
	
	var focusValue = (int(isFocus) * focusSpeed)
	move_and_slide(motion * (speed - focusValue))

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

func _on_DamageBox_area_entered(area:Area2D):
	if area.is_in_group("enemy"):
		damage()

func _on_GrazeBox_area_entered(area:Area2D):
	if area.is_in_group("enemy"):
		emit_signal("graze", grazeValue)