@tool
extends Node
class_name PlayerController

const move_actions: Array[StringName] = [&"up", &"down", &"right", &"left"]

var parent_entity: Character
@export var movement_component: MovementComponent:
	set(value):
		movement_component = value
		update_configuration_warnings()

func _ready() -> void:
	parent_entity = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	for input in move_actions:
		if event.is_action_pressed(input):
			if parent_entity.actionable:
				parent_entity.interact_with(parent_entity.coords + Global.direction_vectors[input])
				return
			CallableBuffer.add(parent_entity.interact_with.bind(parent_entity.coords + Global.direction_vectors[input]), parent_entity.get.bind("actionable"))

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	if get_parent() is not Entity:
		warnings.append("Parent must be Entity.")
	if movement_component == null:
		warnings.append("Movement Component must not be empty.")
	return warnings
