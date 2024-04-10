extends Position2D
class_name BossExplosion

func _ready():
    var root = get_tree().root
    var currentScene = root.get_child(root.get_child_count() - 1)
    for _i in range(5):
        var explosion: CPUParticles2D = load("res://Scenes/Objects/Visuals/Particles/ExplosionParticle.tscn").instance()
        explosion.position = global_position + Vector2(rand_range(-16, 16), rand_range(-16, 16))
        currentScene.call_deferred("add_child", explosion)
        yield(get_tree().create_timer(0.15), "timeout")
    queue_free()