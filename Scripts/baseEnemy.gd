# baseEnemy.gd
extends Area2D
class_name baseEnemy

enum intro {
	none,
	tween,
	special
}

### Variables
export(intro) var introType
export var health: int
export(Resource) var creationProperties
var score: int
onready var invisTimer = $iframeTimer
onready var tween = $Tween
var motion: Vector2
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
	# Calculating the score based on the initial health value
	score = health * 5
	# Intro code
	match(introType):
		intro.tween:
			# Getting the initial position from the resource
			var introEndPos: Vector2 = Vector2(position.x + creationProperties.gotoPos.x,
				position.y + creationProperties.gotoPos.y)
			# Calculating the time to spend for the tween
			var tweenTime: float = global_position.distance_to(introEndPos) / 232
			# Start tweening!
			tween.interpolate_property(self, "position", position, introEndPos, 
					tweenTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
		
		intro.special:
			# Disabling the collision for the intro and setting the enemy in front
			$CollisionShape2D.disabled = true
			z_index = 11
			# Getting the initial position from the resource
			var introEndPos: Vector2 = Vector2(position.x + creationProperties.gotoPos.x,
				position.y + creationProperties.gotoPos.y)
			# Calculating the time to spend for the tween
			var tweenTime: float = global_position.distance_to(introEndPos) / 232
			# Setting the sprite to be double the size
			var sprite = $Sprite
			sprite.scale = Vector2(4,4)
			# Start tweening, but include the sprite as well!
			tween.interpolate_property(self, "position", position, introEndPos, 
					tweenTime, Tween.TRANS_BACK, Tween.EASE_OUT)
			tween.interpolate_property(sprite, "scale", sprite.scale, Vector2(1,1), 
					tweenTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
			
		# Default/None case
		_:
			# Immediately start the enemy's action phase, no tweens
			startAction()
		

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
		var knockBack = abs(motion.x) * 0.025
		position += Vector2(knockBack, 0)
		if health <= 0:
			#Should include death effects and death signal to the spawner
			emit_signal("death", score)
			emit_signal("completed")
			death()

func death():
	# This function will be overriden, but pls don't forget queue_free
	queue_free()

func _on_Enemy_area_entered(area):
	if area.is_in_group("playerProj"):
		damage(area)
			
	if area.is_in_group("enemyLimit"):
		emit_signal("completed")
		queue_free()


func invisOver():
	motion = temp_motion


func startAction():
	# You *MUST* include the super function for reenabling the shots
	if $CollisionShape2D.disabled:
		$CollisionShape2D.disabled = false
		z_index = 5
