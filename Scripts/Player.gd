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
var isGrazing: bool = false
onready var projectileCreator = $projectileCreator
onready var shootTimer = $shootTimer
onready var invisTimer = $iframeTimer
onready var yieldTimer = $yieldTimer

signal healthChange(value)
signal death()

func _ready():
	# Connecting the score update signal to the HUD/Game Manager
	var root = get_tree().root
	var currentScene = root.get_child(root.get_child_count() - 1)
	var HUD = currentScene.get_node("HUD")
	if HUD != null:
		connect("healthChange", HUD, "healthUpdate")
		connect("death", HUD, "gameOver")

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
		GameManager.damageCount = true
		AudioManager.playSound("res://Assets/Audio/SFX/Player/playerHit.wav")
		health -= 1
		emit_signal("healthChange", health)
		invisTimer.start()
		if health <= 0:
			AudioManager.playSound("res://Assets/Audio/SFX/Player/playerDeath.wav")
			emit_signal("death")
			GameManager.deathCount = true
			queue_free()

func enableControl():
	canControl = true

func _on_DamageBox_area_entered(area:Area2D):
	if area.is_in_group("enemy"):
		damage()
		isGrazing = false

func _on_GrazeBox_area_entered(area:Area2D):
	if area.is_in_group("enemy"):
		isGrazing = true
		yieldTimer.start(0.1);yield(yieldTimer,"timeout")
		if isGrazing:
			GameManager.addScore(grazeValue)
			AudioManager.playSound("res://Assets/Audio/SFX/Player/playerGraze.wav")
			isGrazing = false