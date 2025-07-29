@tool
extends Node
class_name MovementComponent

@onready var parent_entity: Entity = get_parent()

var direction: Vector2i:
	set(value):
		direction = value
		
		if direction.x == 0:
			return
		
		parent_entity.scale.x = direction.x
var move_tween: Tween

signal moving
signal moved

func move(target_coords:Vector2i) -> void:
	if move_tween:
		move_tween.kill()
	
	direction = target_coords - parent_entity.coords
	if Global.terrain.is_tile_revealed(target_coords):
		move_tween = Global.terrain.move_to(parent_entity, target_coords)
	else:
		move_tween = Global.terrain.bounce_to(parent_entity, target_coords)
	
	moving.emit()
	await move_tween.finished
	moved.emit()
	
func step(direction:Vector2i):
	if is_moving():
		return
	var target_coords: Vector2i = parent_entity.coords + direction
	await move(target_coords)
	
func is_moving() -> bool:
	if move_tween:
		return move_tween.is_running()
	return false

func _get_configuration_warnings():
	if get_parent() is Entity:
		return []
	return ["Parent must be Entity."]
