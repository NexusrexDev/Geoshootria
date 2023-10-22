# MainMenu.gd
extends Node2D

# Variables
onready var playButton = $Main/Play
onready var settingsPanel = $Settings
onready var masterVolSlider = $Settings/MarginContainer/VBoxContainer/MasterVol/HSlider
onready var musicVolSlider = $Settings/MarginContainer/VBoxContainer/MusicVol/HSlider
onready var sfxVolSlider = $Settings/MarginContainer/VBoxContainer/SFXVol/HSlider
onready var scrSizeSlider = $Settings/MarginContainer/VBoxContainer/ScrSize/HSlider
onready var fullscreenCheck = $Settings/MarginContainer/VBoxContainer/Fullscreen/CheckBox
var settingsFile = "user://settings.save"
var screenSize = 1

func _ready():
	randomize()
	# Grabbing focus on start, allowing keyboard control
	playButton.grab_focus()
	configureSettings()
	# Playing the main menu music
	MusicManager.playTrack("res://Assets/Prototype/Audio/mainfirst.mp3")

func configureSettings():
	getMaxScreenSize()
	readSettingsFile()
	masterVolSlider.value = AudioServer.get_bus_volume_db(0)
	musicVolSlider.value = AudioServer.get_bus_volume_db(1)
	sfxVolSlider.value = AudioServer.get_bus_volume_db(2)
	scrSizeSlider.value = screenSize
	fullscreenCheck.pressed = OS.window_fullscreen
	screenSizeChanged(screenSize)

func readSettingsFile():
	# This method is used to read all the values from a settings file
	var file = File.new()
	if file.file_exists(settingsFile):
		file.open(settingsFile, File.READ)

		# Reading the first 3 values (Audio bus levels)
		for i in range(3):
			AudioServer.set_bus_volume_db(i, file.get_float())

		# Reading the screen size value
		screenSize = int(file.get_var())

		# Reading the last value (Fullscreen boolean)
		OS.window_fullscreen = bool(file.get_var())

		file.close()

func updateSettingsFile():
	# This method is used to overwrite all the values of a settings file
	var file = File.new()
	file.open(settingsFile, File.WRITE)

	# Saving the audio bus levels
	for i in range(3):
		file.store_float(AudioServer.get_bus_volume_db(i))

	# Saving the screen size values
	file.store_var(screenSize)

	# Saving the fullscreen boolean (in 8bits)
	file.store_var(OS.window_fullscreen)

	file.close()

func getMaxScreenSize():
	scrSizeSlider.max_value = int(OS.get_screen_size().x / 640)

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

func screenSizeChanged(value:int):
	screenSize = value
	OS.window_size = Vector2(640 * screenSize, 360 * screenSize);
	OS.center_window()

func fullscreenToggled(button_pressed:bool):
	OS.window_fullscreen = button_pressed

func backPressed():
	# Hiding the settings menu and passing focus to the play button again, saving all data to file
	settingsPanel.visible = false
	updateSettingsFile()
	playButton.grab_focus()

func exitPressed():
	# Shutting the game down
	get_tree().quit()
