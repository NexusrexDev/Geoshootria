extends baseEnemy

var targetPosition: Vector2 = position
var emitterOut: bool = false
var emitterAngle: float = 270
var emitterGap: int = 48

onready var projCreator = $projectileCreator
onready var bossTimer = $bossTimer
onready var emitter1 = $Emitter1
onready var emitter2 = $Emitter2

signal damage(newHealth)

func startAction():
	.startAction()
	var HUD = currentScene.get_node("HUD")
	if HUD != null:
		connect("damage", HUD, "bossUpdate")
	bossActions()

func bossActions():
	if health >= 25:
		phaseOne()
	else:
		phaseTwo()
	
func _process(delta):
	if emitterOut:
		emitter1.position = Vector2(cos(deg2rad(emitterAngle)), sin(deg2rad(emitterAngle))) * emitterGap
		emitterAngle += 48 * delta
	emitter2.position = Vector2(emitter1.position.x, emitter1.position.y) * -1


func phaseOne():
	var positions = [-42, 84, -42]
	for i in range(3):
		yield(aimShoot(), "completed")
		targetPosition = Vector2(position.x, position.y + positions[i])
		yield(get_tree().create_tween().tween_property(self, "position", targetPosition, 0.5), "finished")
	yieldTimer.start(0.4);yield(yieldTimer,"timeout")
	bossActions()


func phaseTwo():
	if !emitterOut:
		AudioManager.playSound("res://Assets/Audio/SFX/Enemy/enemyCharge.wav")
		yield(get_tree().create_tween().tween_property(emitter1, "position", Vector2(0, -emitterGap), 0.25), "finished")
		emitterOut = true
	yield(emitterShoot(1), "completed")
	bossActions()


func death():
	var miniExplosion1: CPUParticles2D = deathExplosion.instance()
	var miniExplosion2: CPUParticles2D = deathExplosion.instance()
	miniExplosion1.position = emitter1.global_position
	miniExplosion2.position = emitter2.global_position
	currentScene.call_deferred("add_child", miniExplosion1)
	currentScene.call_deferred("add_child", miniExplosion2)
	var explosion: BossExplosion = BossExplosion.new()
	explosion.position = position
	currentScene.call_deferred("add_child", explosion)
	queue_free()


func damage(area):
	.damage(area)
	emit_signal("damage", health)

func emitterShoot(shotCount: int):
	var player = currentScene.get_node("Player")
	var angle1 = 180
	var angle2 = 180
	if player:
		angle1 = rad2deg(emitter1.get_angle_to(player.position))
		angle2 = rad2deg(emitter2.get_angle_to(player.position))
	emitter1.get_child(0).angleShoot(0, angle1, shotCount)
	yieldTimer.start(0.15);yield(yieldTimer,"timeout")
	emitter2.get_child(0).angleShoot(0, angle2, shotCount)
	bossTimer.start(0.5);yield(bossTimer,"timeout")


func aimShoot():
	var player = currentScene.get_node("Player")
	var angle = 180
	if player:
		angle = rad2deg(get_angle_to(player.position))
	sprayProjectiles(angle, -1, 15)
	bossTimer.start(1);yield(bossTimer,"timeout")
	if player:
		angle = rad2deg(get_angle_to(player.position))
	sprayProjectiles(angle, 1, 15)
	bossTimer.start(1);yield(bossTimer,"timeout")


func sprayProjectiles(centerAngle: float, direction: int, incrValue: float):
	var angle = centerAngle - (incrValue * direction)
	for _i in range(3):
		projCreator.angleShoot(0, angle)
		setBounce(0.5, angle)
		yieldTimer.start(0.25);yield(yieldTimer,"timeout")
		angle += (incrValue * direction)
