@tool
extends Area2D
class_name HurtBoxComponent

@onready var parent_character: Character = get_parent()
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
	if !parent_character:
		return false
	if attack_data.execute(parent_character):
		hit_taken.emit(attack_data)
		return true
	return false

func _get_configuration_warnings():
	var warnings: PackedStringArray
	if get_parent() is not Character:
		warnings.append("Parent must be Character.")
	#if !stats_component:
		#warnings.append("Stats Component must not be empty.")
	return warnings
