@tool
extends Node
class_name PlayerController

const move_actions: Array[StringName] = [&"up", &"down", &"right", &"left"]

@export var parent_character: Character:
	set(value):
		parent_character = value
		update_configuration_warnings()
@export var movement_component: MovementComponent:
	set(value):
		movement_component = value
		update_configuration_warnings()
#@export var state_machine: LimboHSM:
	#set(value):
		#state_machine = value
		#update_configuration_warnings()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var direction: Vector2 = Input.get_vector(&"left", &"right", &"up", &"down").normalized()
	movement_component.direction = direction

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	if parent_character == null:
		warnings.append("Parent Character must not be empty.")
	if movement_component == null:
		warnings.append("Movement Component must not be empty.")
	#if !state_machine:
		#warnings.append("State Machine must not be empty.")
	return warnings
