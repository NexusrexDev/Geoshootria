extends Node

enum palettes {
    OLD_MUG,
    MIST_GB,
    MOON_GB,
    LAVA_GB
}

# Variables
var volumes: Array = [0, 0, 0]
var screenSize: int = 1
var fullscreen: bool = false
var currentPalette: int = palettes.OLD_MUG
var settingsFile: String = "user://settings.save"

# Functions
func _ready():
    readSettingsFile()


func readSettingsFile() -> void:
	# This method is used to read all the values from a settings file
	var file = File.new()
	if file.file_exists(settingsFile):
		file.open(settingsFile, File.READ)

		# Reading the first 3 values (Audio bus levels)
		for i in range(3):
			setVolume(file.get_float(), i)

		# Reading the screen size value
		setScreenSize(file.get_var())

		# Reading the last value (Fullscreen boolean)
		setFullscreen(file.get_var())

		file.close()


func saveSettingsFile():
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


func setScreenSize(value: int) -> void:
    screenSize = value
    OS.window_size = Vector2(640 * screenSize, 360 * screenSize);
    OS.center_window()


func setVolume(value: float, bus: int) -> void:
    volumes[bus] = value
    AudioServer.set_bus_volume_db(bus, value)


func setFullscreen(value: bool) -> void:
    fullscreen = value
    OS.window_fullscreen = value