@tool
extends Node
class_name StatsComponent

@export var parent_character: Character:
	set(value):
		parent_character = value
		update_configuration_warnings()

@export var base_hp: int = 100
@export var base_mp: int = 10
@export var base_atk: int = 10

@onready var hp: int = base_hp:
	set(value):
		hp = clampi(value, 0, base_hp)
		if !is_alive():
			killed.emit()
@onready var mp: int = base_mp:
	set(value):
		hp = clampi(value, 0, base_mp)
@onready var atk: int = base_atk

signal hit_taken(attack_data: AttackData)
signal damage_taken(amount: int)
signal heal_taken(amount: int)
signal killed

func take_hit(attack_data: AttackData) -> bool:
	var success: bool
	
	if attack_data.mode == AttackData.Mode.DAMAGE:
		success = damage(attack_data.amount)
	else:
		success = heal(attack_data.amount)
	
	if success:
		hit_taken.emit(attack_data)
	
	return success

func damage(amount: int) -> bool:
	if !is_alive():
		return false
	if amount < 0:
		amount = 0
	
	hp -= amount
	damage_taken.emit(amount)
	return true

func heal(amount: int) -> bool:
	if !is_alive():
		return false
	if amount < 0:
		amount = 0
	
	hp += amount
	heal_taken.emit(amount)
	return true

func is_alive() -> bool:
	if hp > 0:
		return true
	return false

func kill() -> void:
	hp = 0

func _get_configuration_warnings() -> PackedStringArray:
	if parent_character != null:
		return []
	return ["Parent Character must not be empty."]
