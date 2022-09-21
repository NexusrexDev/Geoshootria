# MainMenu.gd
extends Node2D

# Variables
onready var playButton = $Main/Play

func _ready():
	playButton.grab_focus()

func playPressed():
	get_tree().change_scene("res://Scenes/Rooms/Level.tscn")


func exitPressed():
	get_tree().quit()
