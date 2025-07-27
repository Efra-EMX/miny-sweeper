extends Area2D
class_name HitBoxComponent

@export var parent_character: Character
@export var attack_data: AttackData

signal hit_success(targets: Array[Character])

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	monitorable = false

func hit(data: AttackData = attack_data) -> Array[Character]:
	if data == null:
		return []
	if parent_character:
		data.attacker = parent_character
		
	var targets: Array[Character] = []
	for area in get_overlapping_areas():
		if area is HurtBoxComponent:
			if area.take_hit(attack_data):
				targets.append(area.parent_character)
	hit_success.emit(targets)
	return targets
