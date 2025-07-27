extends Node

var bgm_volume: float = 1:
	set(value):
		bgm_volume = value
		AudioServer.set_bus_volume_db(1, linear_to_db(value))
var sfx_volume: float = 1:
	set(value):
		sfx_volume = value
		AudioServer.set_bus_volume_db(2, linear_to_db(value))
var window_mode: int:
	set(value):
		window_mode = value
		DisplayServer.window_set_mode(value)
		ProjectSettings.set_setting("display/window/size/mode", value)
		#WindowManager.window_mode_changed.emit()

func _enter_tree() -> void:
	load_settings()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_CRASH:
		print_debug("Closing...")
		save_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	
	config.set_value("audio", "bgm_volume", bgm_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("display", "window/size/mode", DisplayServer.window_get_mode())
	#config.set_value("display", "window/size/window_width_override", ProjectSettings.get_setting("display/window/size/window_width_override"))
	#config.set_value("display", "window/size/window_height_override", ProjectSettings.get_setting("display/window/size/window_height_override"))
	
	var error: Error = config.save("user://settings.cfg")
	if error != OK:
		print_debug(error)
		return
	print_debug("Settings saved")

func load_settings() -> void:
	var config:= ConfigFile.new()
	var error: Error = config.load("user://settings.cfg")
	# If the file didn't load, ignore it.
	if error != OK:
		print_debug(error)
		return
	
	bgm_volume = config.get_value("audio", "bgm_volume", 1)
	sfx_volume = config.get_value("audio", "sfx_volume", 1)
	
	print_debug("Settings loaded")
