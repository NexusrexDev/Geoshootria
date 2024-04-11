extends Node

# Variables
var currentScore: int = 0
var currentLevel: int = 0
var highScore: int = 0
var highscoreBroken: bool = false
var highscoreFile: String = "user://highscore.save"
var deathCount: bool = false
var damageCount: bool = false

var levelPaths: PoolStringArray = ["res://Scenes/Rooms/Level1.tscn", "res://Scenes/Rooms/Level2.tscn"]

# Signals
signal scoreChanged()
signal cameraShake(value)

# Functions
func _ready():
    readHighScore()

func resetScore():
    currentScore = 0
    highscoreBroken = false
    damageCount = false

func resetGame():
    currentScore = 0
    currentLevel = 0
    highscoreBroken = false
    deathCount = false
    damageCount = false
    readHighScore()

func addScore(score: int):
    currentScore += score
    if currentScore > highScore:
        highScore = currentScore
        highscoreBroken = true
    emit_signal("scoreChanged")

func readHighScore():
    var file = File.new()
    if file.file_exists(highscoreFile):
        file.open(highscoreFile, File.READ)
        highScore = file.get_var()
        file.close()

func updateHighScore():
    var file = File.new()
    file.open(highscoreFile, File.WRITE)
    file.store_var(highScore)
    file.close()


# Visual helpers
func freezeFrame(timeScale: float, duration: float):
    Engine.time_scale = timeScale
    yield(get_tree().create_timer(duration * timeScale), "timeout")
    Engine.time_scale = 1.0


func shakeCamera(value: float):
    emit_signal("cameraShake", value)


func _process(_delta):
    if Input.is_key_pressed(KEY_F5):
        var image: Image = get_viewport().get_texture().get_data();image.flip_y()
        image.save_png("res://Scenes/Recording/Screenshots/" + str(OS.get_unix_time()) + ".png")