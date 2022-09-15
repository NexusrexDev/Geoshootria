extends Resource
class_name Spawnable

#Using an enum instead of relying on packedScenes
enum enemyType {
	enemy1,
	enemy2,
	enemy3,
	enemy4
}

export(enemyType) var type
export(Vector2) var position
export(float) var pauseTime
export(int) var extraProperty
