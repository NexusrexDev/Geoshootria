# MainMenu.gd
extends Node2D

# Variables
onready var playButton = $Main/Play
onready var settingsPanel = $Settings
onready var masterVolSlider = $Settings/MarginContainer/VBoxContainer/MasterVol/HSlider
onready var musicVolSlider = $Settings/MarginContainer/VBoxContainer/MusicVol/HSlider
onready var sfxVolSlider = $Settings/MarginContainer/VBoxContainer/SFXVol/HSlider
onready var fullscreenCheck = $Settings/MarginContainer/VBoxContainer/Fullscreen/CheckBox

func _ready():
	# Grabbing focus on start, allowing keyboard control
	playButton.grab_focus()
	configureSettings()

func configureSettings():
	# Reading the values from the system temporarily, should also read from a file when available
	masterVolSlider.value = AudioServer.get_bus_volume_db(0)
	musicVolSlider.value = AudioServer.get_bus_volume_db(1)
	sfxVolSlider.value = AudioServer.get_bus_volume_db(2)
	fullscreenCheck.pressed = OS.window_fullscreen

func playPressed():
	# Moving to the gameplay scene, should be replaced with a fadeout first
	get_tree().change_scene("res://Scenes/Rooms/Level.tscn")

func settingsPressed():
	# Triggering the settings menu to show up and passing focus to the first slider
	settingsPanel.visible = true
	masterVolSlider.grab_focus()

func masterVolChanged(value:float):
	AudioServer.set_bus_volume_db(0, value)

func musicVolChanged(value:float):
	AudioServer.set_bus_volume_db(1, value)

func sfxVolChanged(value:float):
	AudioServer.set_bus_volume_db(2, value)

func fullscreenToggled(button_pressed:bool):
	OS.window_fullscreen = button_pressed

func backPressed():
	# Hiding the settings menu and passing focus to the play button again
	settingsPanel.visible = false
	playButton.grab_focus()

func exitPressed():
	# Shutting the game down
	get_tree().quit()