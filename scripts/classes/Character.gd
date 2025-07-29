extends Entity
class_name Character

@onready var stats_component: StatsComponent = $StatsComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var mining_component: Node = $MiningComponent
@onready var state_machine: GenericHSM = $StateMachine

func take_hit(attack_data: AttackData) -> bool:
	if !stats_component:
		return false
	return stats_component.take_hit(attack_data)

func interact_with(coords: Vector2i) -> void:
	#if not actionable:
		#return
	
	actionable = false
	
	if Global.terrain.is_tile_revealed(coords):
		var target_entity: Entity = get_entity_on_coords(coords)
		if target_entity == null:
			await movement_component.move(coords)
		else:
			await target_entity.interact(self)
	elif mining_component != null:
		await mining_component.mine(coords)
	
	await super.interact_with(coords)
	
	actionable = true
