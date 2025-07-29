extends Node2D
class_name Entity

var coords: Vector2i:
	set(value):
		global_position = Global.terrain.coords_to_position(value)
	get():
		return get_coords()

func _ready() -> void:
	coords = coords

func get_coords() -> Vector2i:
	return Global.terrain.position_to_coords(global_position)

func take_hit(attack_data: AttackData) -> bool:
	return false
