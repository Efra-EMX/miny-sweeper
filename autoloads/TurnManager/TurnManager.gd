extends LimboHSM

@export var anystate_transitions: Dictionary

var turn_counter: int = 0

signal player_turn
signal enemy_turn
signal new_turn

func _ready() -> void:
	for event:StringName in anystate_transitions:
		var state: LimboState = get_node_or_null(anystate_transitions[event])
		if state == null:
			continue
		add_transition(ANYSTATE, get_node(anystate_transitions[event]), event)
	
	initialize.call_deferred(self)
	set_active.call_deferred(true)

func start() -> void:
	dispatch("Idle")
	turn_counter = 0
	dispatch("PlayerTurn")

func stop() -> void:
	#turn_counter = 0
	dispatch("Idle")

func is_running() -> bool:
	return $PlayerTurn.is_active() or $EnemyTurn.is_active()

func is_any_entity_actionable() -> bool:
	var all_entities: Array = get_tree().get_nodes_in_group("entity")
	
	for entity in all_entities:
		if entity.actionable:
			return true
	return false

func is_any_entity_busy() -> bool:
	var all_entities: Array = get_tree().get_nodes_in_group("entity")
	
	for entity in all_entities:
		if entity.busy:
			return true
	return false

#func next_turn() -> void:
	#print_debug(turn_counter)
	#turn_counter += 1
	#new_turn.emit()
