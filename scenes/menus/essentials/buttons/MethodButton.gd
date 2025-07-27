extends Button
class_name MethodButton

@export var node:Node
@export var method_name: String
@export var arguments: Array

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)

func on_pressed() -> void:
	if node == null || method_name == null:
		return
	if not node.has_method(method_name):
		return
	AudioManager.play(&"confirm")
	if arguments != null:
		node.callv(method_name, arguments)
		return
	node.call(method_name)

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
