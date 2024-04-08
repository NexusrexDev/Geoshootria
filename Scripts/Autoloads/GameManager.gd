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

# Functions
func _ready():
    readHighScore()

func resetScore():
    currentScore = 0
    highscoreBroken = false

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