extends baseEnemy

var initialPosition: Vector2 = position
var startHover: bool = false
var sineX: float = 0
var sineIncrement: float = 1
var verticalSpeed: float = 40
var sineDirection: int = -1

onready var projCreator = $projectileCreator
onready var bossTimer = $bossTimer

signal damage(newHealth)

func startAction():
	.startAction()
	startHover = true
	var HUD = currentScene.get_node("HUD")
	if HUD != null:
		connect("damage", HUD, "bossUpdate")
	bossActions()


func bossActions():
	if health >= 55:
		phaseOne()
	elif health >= 25:
		phaseTwo()
	else:
		phaseThree()


func phaseOne():
	var player = currentScene.get_node("Player")
	var angle = 180
	if player:
		angle = rad2deg(get_angle_to(player.position))
	yield(sprayProjectiles(angle, -1, 10), "completed")
	bossTimer.start(0.1);yield(bossTimer,"timeout")
	yield(sprayProjectiles(angle, 1, 10), "completed")
	bossTimer.start(0.6);yield(bossTimer,"timeout")
	bossActions()


func phaseTwo():
	yield(radialShots(), "completed")
	bossActions()


func phaseThree():
	yield(spearShot(), "completed")
	bossActions()


func spearShot():
	var player = currentScene.get_node("Player")
	var angle = 180
	if player:
		angle = rad2deg(get_angle_to(player.position))
	for i in range(3):
		projCreator.angleShoot(0, angle, i+1)
		setBounce(0.5, angle)
		yieldTimer.start(0.1);yield(yieldTimer,"timeout")
	bossTimer.start(0.6);yield(bossTimer,"timeout")


func radialShots():
	var angle = 0
	for _i in range(9):
		projCreator.radialShoot(0, angle, 10)
		angle += 10
		yieldTimer.start(0.4);yield(yieldTimer,"timeout")


func spreadShot(direction: int):
	var angle = 200 if direction == -1 else 160
	for _i in range(3):
		yield(triShot(angle, direction), "completed")
		angle += (15 * direction)
		yieldTimer.start(0.25);yield(yieldTimer,"timeout")


func sprayProjectiles(centerAngle: float, direction: int, incrValue: float):
	var angle = centerAngle - (incrValue * direction)
	for _i in range(3):
		projCreator.angleShoot(0, angle)
		setBounce(0.5, angle)
		yieldTimer.start(0.1);yield(yieldTimer,"timeout")
		angle += (incrValue * direction)


func triShot(angle: float, direction: int):
	for i in range(3):
		projCreator.angleShoot(0, angle + (direction * i * 5))
		setBounce(0.5, angle)
		yieldTimer.start(0.1);yield(yieldTimer,"timeout")


func death():
	var explosion: BossExplosion = BossExplosion.new()
	explosion.position = position
	currentScene.call_deferred("add_child", explosion)
	queue_free()


func damage(area):
	.damage(area)
	emit_signal("damage", health)


func _process(delta):
	if startHover:
		sineX += delta * sineIncrement
		var verticalMotion: float = cos(sineX) * verticalSpeed * (-sineDirection)
		motion.y = verticalMotion
