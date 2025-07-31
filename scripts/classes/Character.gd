extends Entity
class_name Character

@onready var movement_component: MovementComponent = $MovementComponent
@onready var mining_component: MiningComponent = $MiningComponent
@onready var state_machine: GenericHSM = $StateMachine

func _ready() -> void:
	if is_in_group("player"):
		TurnManager.player_turn.connect(set.bind("actionable", true))
	elif is_in_group("enemy"):
		TurnManager.enemy_turn.connect(set.bind("actionable", true))
	super._ready()

func interact_with(coords: Vector2i) -> void:
	if not actionable:
		return
	
	actionable = false
	busy = true
	
	if Global.terrain.is_tile_revealed(coords):
		var target_entity: Entity = get_entity_on_coords(coords)
		if target_entity == null:
			await movement_component.move(coords)
		else:
			await target_entity.interact(self)
	elif mining_component != null:
		await mining_component.mine(coords)
	
	await super.interact_with(coords)
	
	busy = false
