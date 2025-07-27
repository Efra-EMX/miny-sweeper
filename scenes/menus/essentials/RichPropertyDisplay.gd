extends RichTextLabel
class_name RichPropertyDisplay

@export var node: Node
@export var property_path: String
@export var text_format: String = "%s"

var value

func _process(_delta: float) -> void:
	if node == null:
		return
	var new_value = node.get(property_path)
	if value == new_value:
		return
	value = new_value
	update_text()

func update_text() -> void:
	text = text_format % value
