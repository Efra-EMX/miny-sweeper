@tool
extends Node
class_name TopDownController

@export var enabled: bool = true
@export var speed:float = 100.0
@export_range(0.0, 2.0) var speed_modifier: float = 1
#@export var flip_node: Node2D

@export var parent_character: CharacterBody2D:
	set(value):
		parent_character = value
		update_configuration_warnings()

func _physics_process(delta) -> void:
	if Engine.is_editor_hint():
		return
	
	if !enabled:
		return
		
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		parent_character.velocity = direction * speed * speed_modifier
		parent_character.move_and_slide()
		
		#if flip_node:
			#if direction.x > 0:
				#flip_node.scale.x = 1
				#return
			#if direction.x < 0:
				#flip_node.scale.x = -1
				#return
	#else:
		#parent_character.velocity = Vector2.ZERO

func _get_configuration_warnings() -> PackedStringArray:
	if parent_character != null:
		return []
	return ["This node must be a child of CharacterBody2D"]
