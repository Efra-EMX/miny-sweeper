extends Node
class_name MiningComponent

@onready var parent_entity: Entity = get_parent()

func mine(coords: Vector2i) -> void:
	parent_entity.direction = parent_entity.global_position.direction_to(Global.terrain.coords_to_position(coords))
	$"../AnimationPlayer".play("Mine")
	await $"../AnimationPlayer".animation_finished
	$"../AnimationPlayer".play("Idle")
	await Global.terrain.break_tile(coords)
