# Teleporter.gd
extends Position2D

# Variables
export(PackedScene) var enemyReference
export var spawnTime: float
var introProperties: Resource
var actionProperties: Resource
onready var animationNode = $anim

func _ready():
	yield(get_tree().create_timer(spawnTime, false), "timeout")

	var enemy = enemyReference.instance()
	enemy.position = Vector2(global_position.x, global_position.y + 16)
	enemy.introProperties = introProperties
	enemy.actionProperties = actionProperties
	get_parent().call_deferred("add_child", enemy)

	if animationNode is CPUParticles2D:
		animationNode.emitting = false
	yield(get_tree().create_timer(0.8, false), "timeout")
	queue_free()
