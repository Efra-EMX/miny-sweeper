@tool
extends Node
class_name MovementComponent

@export var parent_character: Character:
	set(value):
		parent_character = value
		update_configuration_warnings()
@export var speed:float = 100.0
@export_range(0.0, 2.0) var speed_modifier: float = 1

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta) -> void:
	if Engine.is_editor_hint():
		return
	#if direction == Vector2.ZERO:
		#return
	parent_character.velocity = direction * speed * speed_modifier
	parent_character.move_and_slide()

func _get_configuration_warnings() -> PackedStringArray:
	if parent_character:
		return []
	return ["Parent Character must not be empty."]
