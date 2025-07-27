extends Control

@onready var bgm_slider: HSlider = $Sliders/BGM
@onready var sfx_slider: HSlider = $Sliders/SFX
@onready var fullscreen_check: CheckButton = $Fullscreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_visible_in_tree():
		on_visibility_changed()
	visibility_changed.connect(on_visibility_changed)

func on_bgm_value_changed(value: float) -> void:
	AudioManager.play("select")
	Settings.bgm_volume = value

func on_sfx_value_changed(value: float) -> void:
	AudioManager.play("select")
	Settings.sfx_volume = value

func on_fullscreen_toggled(button_pressed: bool) -> void:
	AudioManager.play("confirm")
	if button_pressed:
		Settings.window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		return
	Settings.window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	get_window().size = Vector2i(
		ProjectSettings.get_setting_with_override("display/window/size/window_width_override"),
		ProjectSettings.get_setting_with_override("display/window/size/window_height_override")
	)
func on_visibility_changed() -> void:
	if !is_visible_in_tree():
		bgm_slider.value_changed.disconnect(on_bgm_value_changed)
		sfx_slider.value_changed.disconnect(on_sfx_value_changed)
		return
	update_display()
	bgm_slider.value_changed.connect(on_bgm_value_changed)
	sfx_slider.value_changed.connect(on_sfx_value_changed)

func update_display() -> void:
	bgm_slider.value = Settings.bgm_volume
	sfx_slider.value = Settings.sfx_volume
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_check.set_pressed_no_signal(true)
		return
	fullscreen_check.set_pressed_no_signal(false)
