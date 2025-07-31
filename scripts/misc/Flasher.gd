@tool
extends Node
class_name Flasher

@export var flash_color: Color = Color(5, 5, 5)
@onready var parent: Node2D = get_parent()

var tween: Tween

func flash() -> void:
	if Engine.is_editor_hint():
		return
	if tween:
		tween.kill()
	
	var original_modulate: Color = Color(1, 1, 1)
	parent.modulate = flash_color
	
	tween = create_tween()
	tween.tween_property(parent, "modulate", original_modulate, 0.2)

func _get_configuration_warnings():
	if parent is Node2D:
		return []
	return ["Parent must be Node2D."]
