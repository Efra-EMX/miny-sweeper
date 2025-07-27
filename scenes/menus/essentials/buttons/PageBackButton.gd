extends Button
class_name PageBackButton

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	if shortcut:
		return
	var input := InputEventAction.new()
	input.action = "ui_cancel"
	shortcut = Shortcut.new()
	shortcut.events = [input]
	shortcut_feedback = false
	shortcut_in_tooltip = false
	shortcut_context = Page.get_page_of(self)

func on_pressed() -> void:
	AudioManager.play(&"cancel")
	Page.back()

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
