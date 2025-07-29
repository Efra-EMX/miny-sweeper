extends Entity
class_name Character

@onready var stats_component: StatsComponent = $StatsComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: GenericHSM = $StateMachine

func take_hit(attack_data: AttackData) -> bool:
	if !stats_component:
		return false
	return stats_component.take_hit(attack_data)
