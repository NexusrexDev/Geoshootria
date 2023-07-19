extends Node2D

export(PackedScene) var enemyScene
export(Vector2) var spawnPosition
export(Resource) var introProperties
export(Resource) var actionProperties

func _process(_delta):
	if Input.is_action_just_released("ui_customspawn"):
		var enemy = enemyScene.instance()
		enemy.position = spawnPosition
		enemy.introProperties = introProperties
		enemy.actionProperties = actionProperties
		add_child(enemy)
