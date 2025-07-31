extends Node2D
class_name Entity

@onready var stats_component: StatsComponent = $StatsComponent

var coords: Vector2i
	#set(value):
		#global_position = Global.terrain.coords_to_position(value)
		
	#get():
		#return get_coords()
		
var direction: Vector2i:
	set(value):
		direction = value
		
		if direction.x == 0:
			return
		
		scale.x = direction.x
var actionable: bool = false
var busy: bool = false

func _ready() -> void:
	coords = get_coords()
	
	if stats_component != null:
		stats_component.killed.connect(on_killed)

func set_coords(new_coords: Vector2i) -> void:
	coords = new_coords
	global_position = Global.terrain.coords_to_position(new_coords)

func get_coords() -> Vector2i:
	return Global.terrain.position_to_coords(global_position)

func take_hit(attack_data: AttackData) -> bool:
	if stats_component == null:
		return false
	return stats_component.take_hit(attack_data)

func on_killed() -> void:
	queue_free()

func interact(from: Entity = null) -> void:
	pass

func interact_with(coords: Vector2i) -> void:
	#TODO get entity on coords, and then call entity_name.interact(self)
	pass

static func get_entity_on_coords(coords: Vector2i) -> Entity:
	for entity:Entity in Global.get_tree().get_nodes_in_group("entity"):
		if entity.coords == coords:
			return entity
	return null
