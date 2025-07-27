extends Button
class_name PageSwitchButton

@export var target_page: Page

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)

func on_pressed() -> void:
	AudioManager.play(&"confirm")
	Page.switch_page(target_page)

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
	
