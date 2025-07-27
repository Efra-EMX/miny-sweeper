extends Button

@export var show_node: Control
@export var hide_node: Control
@export var grab_node: Control
@export var shortcut_action: String

func _ready():
	pressed.connect(on_button_pressed)
	mouse_entered.connect(func(): AudioManager.play(&"select"))

func on_button_pressed() -> void:
	AudioManager.play("confirm")
	if show_node != null:
		show_node.show()
	if hide_node != null:
		hide_node.hide()
	if grab_node != null:
		grab_node.grab_focus()

func _input(event) -> void:
	if !is_visible_in_tree() || shortcut_action == "":
		return
	if event.is_action_pressed(shortcut_action):
		on_button_pressed()
		
