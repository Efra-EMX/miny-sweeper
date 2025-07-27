@tool
extends Area2D
class_name HurtBoxComponent

@export var parent_character: Character:
	set(value):
		parent_character = value
		update_configuration_warnings()
#@export var stats_component: StatsComponent:
	#set(value):
		#stats_component = value
		#update_configuration_warnings()

signal hit_taken(attack_data: AttackData)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	monitoring = false

func take_hit(attack_data: AttackData) -> bool:
	if parent_character == null:
		return false
	if attack_data.execute(parent_character):
		hit_taken.emit(attack_data)
		return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if parent_character == null:
		warnings.append("Parent Character must not be empty.")
	#if stats_component == null:
		#warnings.append("Stats Component must not be empty.")
	return warnings
