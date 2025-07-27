extends Button
class_name QuitButton

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)

func on_pressed() -> void:
	AudioManager.play(&"confirm")
	Settings.save_settings()
	get_tree().quit()

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
