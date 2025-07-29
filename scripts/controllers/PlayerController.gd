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
			if not movement_component.is_moving():
				movement_component.step(Global.direction_vectors[input])
				return
			CallableBuffer.add(movement_component.step.bind(Global.direction_vectors[input]), movement_component.is_moving, true)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	if get_parent() is not Entity:
		warnings.append("Parent must be Entity.")
	if movement_component == null:
		warnings.append("Movement Component must not be empty.")
	return warnings
