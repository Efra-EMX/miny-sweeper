extends Label
class_name MethodDisplay

@export var node: Node
@export var method_name: String
@export var arguments: Array
@export var text_format: String = "%s"

var value

func _process(_delta: float) -> void:
	if !node || !method_name:
		return
	if !node.has_method(method_name):
		return
		
	var new_value
	
	if arguments:
		new_value = node.callv(method_name, arguments)
	else:
		new_value = node.call(method_name)
	
	if value == new_value:
		return
	value = new_value
	update_text()

func update_text():
	text = text_format % value
