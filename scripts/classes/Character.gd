extends Entity
class_name Character

@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: GenericHSM = $StateMachine

func _ready() -> void:
	if is_in_group("player"):
		TurnManager.player_turn.connect(set.bind("actionable", true))
	elif is_in_group("enemy"):
		TurnManager.enemy_turn.connect(set.bind("actionable", true))
		#TurnManager.enemy_turn.connect(state_machine.dispatch.bind("act"))
	super._ready()

func interact_with(coords: Vector2i) -> void:
	super.interact_with(coords)
