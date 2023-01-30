# MainMenu.gd
extends Node2D

# Variables
onready var playButton = $Main/Play
onready var settingsPanel = $Settings
onready var masterVolButton = $Settings/MarginContainer/VBoxContainer/MasterVol/HSlider

func _ready():
	# Grabbing focus on start, allowing keyboard control
	playButton.grab_focus()

func configureSettings():
	pass

func playPressed():
	# Moving to the gameplay scene, should be replaced with a fadeout first
	get_tree().change_scene("res://Scenes/Rooms/Level.tscn")

func settingsPressed():
	# Triggering the settings menu to show up and passing focus to the first slider
	settingsPanel.visible = true
	masterVolButton.grab_focus()

func masterVolChanged(value:float):
	print("Master volume: " + str(value))

func sfxVolChanged(value:float):
	print("SFX volume: " + str(value))

func musicVolChanged(value:float):
	print("Music volume: " + str(value))

func fullscreenToggled(button_pressed:bool):
	print("Fullscreen mode: " + str(button_pressed))

func backPressed():
	# Hiding the settings menu and passing focus to the play button again
	settingsPanel.visible = false
	playButton.grab_focus()

func exitPressed():
	# Shutting the game down
	get_tree().quit()