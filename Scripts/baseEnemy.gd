# baseEnemy.gd
extends Area2D
class_name baseEnemy

enum intro {
	none,
	tween,
	foreground
}

### Variables
export(intro) var introType
export var health: int
export(Resource) var introProperties
export(Resource) var actionProperties
export(Resource) var outroProperties
export var isBoss: bool
var score: int
onready var tween: Tween = $Tween
onready var spriteAnchor: Position2D = $SpriteAnchor
var motion: Vector2
var temp_motion: Vector2
var flashTimer: Timer
var shakeVal: float = 0
var bounceVal: float = 0
var bounceDir: float = 0
export(PackedScene) var deathExplosion: PackedScene = preload("res://Scenes/Objects/Visuals/Particles/ExplosionParticle.tscn")

var currentScene: Node

signal completed()


func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

	z_index = -2
	flashTimer = Timer.new()
	add_child(flashTimer)
	signalPrep()

	# Calculating the score based on the initial health value
	if isBoss:
		score = health * 10
	else:
		score = health * 5

	startIntro()


func signalPrep():
	# Connecting the death and safe passing/destruction to the spawner
	var Spawner = currentScene.get_node("Spawner")
	if Spawner != null:
		connect("completed", Spawner, "enemyPassed")
	# Connecting the flash timer to the reset function
	flashTimer.connect("timeout", self, "resetFlash")


func startIntro():
	# Forcing the introType to change if a resource is set
	if introProperties != null:
		introType = intro.tween

	# Intro code
	match(introType):
		intro.tween:
			# Getting the initial position from the resource
			var introEndPos: Vector2 = Vector2(position.x + introProperties.gotoPos.x,
				position.y + introProperties.gotoPos.y)
			# Calculating the time to spend for the tween
			var tweenTime: float = global_position.distance_to(introEndPos) / 190
			# Start tweening!
			tween.interpolate_property(self, "position", position, introEndPos, 
					tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		
		intro.foreground:
			# Disabling the collision for the intro and setting the enemy in front
			$CollisionShape2D.disabled = true
			z_index = 11
			# Getting the initial position from the resource
			var introEndPos: Vector2 = Vector2(position.x + introProperties.gotoPos.x,
				position.y + introProperties.gotoPos.y)
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

	# Resetting the anchor to it's original size
	spriteAnchor.scale = spriteAnchor.scale.linear_interpolate(Vector2(1,1), delta * 4)

	# Shaking effect
	if shakeVal:
		shakeVal = max(0, shakeVal - delta * 0.8)
		shake()

	# Bouncing effect
	if bounceVal:
		spriteAnchor.position = Vector2(cos(bounceDir), sin(bounceDir)) * bounceVal * 8
		bounceVal = max(0, bounceVal - (delta * 2.5))

func setBounce(value: float, angle: float):
	bounceVal = value
	bounceDir = deg2rad(angle + 180)

func shake():
	# Randomly shaking the enemy
	var shakeX = rand_range(-shakeVal, shakeVal) * 8
	var shakeY = rand_range(-shakeVal, shakeVal) * 8
	spriteAnchor.position = Vector2(shakeX, shakeY)


func damage(area):
	health -= 1
	spriteAnchor.scale = Vector2(1.25, 0.75)
	spriteAnchor.modulate = Color(10,10,10,10)
	flashTimer.start(0.1)
	shakeVal = 0.25
	area.queue_free()
	if health <= 0:
		#Should include death effects and death signal to the spawner
		GameManager.addScore(score)
		emit_signal("completed")
		death()


func death():
	var explosion: CPUParticles2D = deathExplosion.instance()
	explosion.position = global_position
	currentScene.call_deferred("add_child", explosion)
	queue_free()


func resetFlash():
	spriteAnchor.modulate = Color(1,1,1,1)


func _on_Enemy_area_entered(area):
	if area.is_in_group("playerProj"):
		damage(area)
			
	if area.is_in_group("enemyLimit"):
		emit_signal("completed")
		queue_free()


func startAction():
	# You *MUST* include the super function for reenabling the shots
	if $CollisionShape2D.disabled:
		$CollisionShape2D.disabled = false
		z_index = 5


func startOutro():
	pass
