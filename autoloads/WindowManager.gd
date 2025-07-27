extends Node

@onready var window: Window = get_tree().root
@onready var base_size: Vector2i = Vector2i(
	ProjectSettings.get_setting_with_override("display/window/size/viewport_width"),
	ProjectSettings.get_setting_with_override("display/window/size/viewport_height")
)
@onready var size_override: Vector2i = Vector2i(
	ProjectSettings.get_setting_with_override("display/window/size/window_width_override"),
	ProjectSettings.get_setting_with_override("display/window/size/window_height_override")
)

signal window_mode_changed

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	window.size_changed.connect(window_size_changed)
	window_mode_changed.connect(on_window_mode_changed)
	window.min_size = base_size
	
	if FileAccess.file_exists("user://settings.cfg"):
		return
	var scale: Vector2i = (DisplayServer.screen_get_size() / base_size) / 2
	size_override = base_size * (scale.y if scale.y <= scale.x else scale.x)
	
	ProjectSettings.set_setting("display/window/size/window_width_override", size_override.x)
	ProjectSettings.set_setting("display/window/size/window_height_override", size_override.y)
	
	if window.mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window.size = size_override
		window.move_to_center()
	
	#if window.mode == DisplayServer.WINDOW_MODE_WINDOWED:
		#window.position = (DisplayServer.screen_get_size() - size_override) / 2
		#print_debug("Set window position: ", window.position)

func window_size_changed() -> void:
	var scale: Vector2i = window.size / base_size
	window.content_scale_size = window.size / (scale.y if scale.y <= scale.x else scale.x)

func on_window_mode_changed() -> void:
	if Settings.window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window.size = size_override
		print_debug("Resized to ", window.size)
		#center_windowed.call_deferred()

#func center_windowed() -> void:
	#window.position = (DisplayServer.screen_get_size() - size_override) / 2
	#print_debug("Set window position: ", window.position)
