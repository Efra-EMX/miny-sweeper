extends Button

@export var url: String

func _ready() -> void:
	pressed.connect(on_button_pressed)
	mouse_entered.connect(on_mouse_entered)

func on_button_pressed() -> void:
	AudioManager.play(&"confirm")
	OS.shell_open(url)

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
