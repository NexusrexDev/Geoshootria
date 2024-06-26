# MainMenu.gd
extends Control

# Variables
onready var playButton = $Main/Play
onready var settingsPanel = $Settings
onready var masterVolSlider = $Settings/Back/VBoxContainer/MasterVol/HSlider
onready var musicVolSlider = $Settings/Back/VBoxContainer/MusicVol/HSlider
onready var sfxVolSlider = $Settings/Back/VBoxContainer/SFXVol/HSlider
onready var scrSizeSlider = $Settings/Back/VBoxContainer/ScrSize/HSlider
onready var fullscreenCheck = $Settings/Back/VBoxContainer/Fullscreen/CheckBox

func _ready():
	randomize()
	# Grabbing focus on start, allowing keyboard control
	playButton.grab_focus()
	configureSettings()
	# Playing the main menu music
	AudioManager.playMusic("res://Assets/Audio/Music/MainMenu.ogg")

func configureSettings():
	getMaxScreenSize()
	masterVolSlider.value = SettingsManager.volumes[0]
	musicVolSlider.value = SettingsManager.volumes[1]
	sfxVolSlider.value = SettingsManager.volumes[2]
	scrSizeSlider.value = SettingsManager.screenSize
	fullscreenCheck.pressed = SettingsManager.fullscreen

func getMaxScreenSize():
	scrSizeSlider.max_value = int(OS.get_screen_size().x / 640)

func playPressed():
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	playButton.release_focus()
	var transition: FadeTransition = load("res://Scenes/Objects/Visuals/Transition.tscn").instance()
	transition.fade_mode = FadeTransition.fadeType.FADE_OUT
	transition.targetScene = "res://Scenes/Rooms/Level1.tscn"
	add_child(transition)

func settingsPressed():
	# Triggering the settings menu to show up and passing focus to the first slider
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	settingsPanel.visible = true
	masterVolSlider.grab_focus()

func masterVolChanged(value:float):
	if masterVolSlider.has_focus():
		AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	SettingsManager.setVolume(value, 0)

func musicVolChanged(value:float):
	if musicVolSlider.has_focus():
		AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	SettingsManager.setVolume(value, 1)

func sfxVolChanged(value:float):
	if sfxVolSlider.has_focus():
		AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	SettingsManager.setVolume(value, 2)

func screenSizeChanged(value:int):
	if scrSizeSlider.has_focus():
		AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	SettingsManager.setScreenSize(value)

func fullscreenToggled(button_pressed:bool):
	if fullscreenCheck.has_focus():
		AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	SettingsManager.setFullscreen(button_pressed)

func backPressed():
	# Hiding the settings menu and passing focus to the play button again, saving all data to file
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	settingsPanel.visible = false
	SettingsManager.saveSettingsFile()
	playButton.grab_focus()

func exitPressed():
	# Shutting the game down
	AudioManager.playSound("res://Assets/Audio/SFX/UI/menuSelect.wav")
	get_tree().quit()
