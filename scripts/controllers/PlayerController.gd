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
	if not parent_entity.actionable:
		return
	
	for input in move_actions:
		if event.is_action_pressed(input):
			#parent_entity.interact_with(parent_entity.coords + Global.direction_vectors[input])
			parent_entity.direction = Global.direction_vectors[input]
			parent_entity.state_machine.dispatch("act")
			return
			#CallableBuffer.add(parent_entity.interact_with.bind(parent_entity.coords + Global.direction_vectors[input]), parent_entity.get.bind("actionable"))
	
	if event is InputEventMouseButton:
		if event.pressed:
			return
		
		if event.button_index == MOUSE_BUTTON_LEFT and parent_entity.stats_component.mp > 0:
			var mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
			var coords: Vector2i = Global.terrain.base_tilemap.local_to_map(Global.terrain.base_tilemap.to_local(mouse_position))
			
			if not Global.terrain.is_tile_loaded(coords):
				return
			if not Global.terrain.is_tile_revealed(coords):
				return
			if not parent_entity.is_tile_within_range(coords):
				return
			
			parent_entity.direction = round(Vector2(parent_entity.coords).direction_to(coords))
			
			%AnimationPlayer.play("Throw")
			PopUpManager.pop_text([
				"Fire in the hole!",
				"Take this!",
				"Kaboom!"
			].pick_random(), Global.terrain.coords_to_position(parent_entity.coords) + Vector2(0,-12))
			await %AnimationPlayer.animation_finished
			%AnimationPlayer.play("Idle")
			
			var new_bomb: Entity = preload("uid://b3wjebir88nf8").instantiate()
			new_bomb.position = Global.terrain.coords_to_position(parent_entity.coords)
			Global.stage.add_child(new_bomb)
			new_bomb.coords = coords
			new_bomb.interact()
			AudioManager.play("drop")
			
			Global.terrain.move_to(new_bomb, coords)
			
			parent_entity.actionable = false
			parent_entity.stats_component.mp -= 1
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	if get_parent() is not Entity:
		warnings.append("Parent must be Entity.")
	if movement_component == null:
		warnings.append("Movement Component must not be empty.")
	return warnings
