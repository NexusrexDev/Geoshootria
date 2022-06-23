# spawnableResource.gd
tool
extends Resource
class_name SpawnPattern

# Variables
export(Array, Resource) var enemy setget set_custom_res

func set_custom_res(value):
	enemy.resize(value.size())
	enemy = value
	for i in enemy.size():
		if not enemy[i]:
			enemy[i] = Spawnable.new()
			enemy[i].resource_name = "Enemy " + str(i+1)
