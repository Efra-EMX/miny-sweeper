extends LimboState

@export var transitions: Dictionary = {
	&"finished": NodePath()
}

@onready var hsm: LimboHSM = get_root()

func _ready() -> void:
	for event:StringName in transitions:
		var state: LimboState = get_node_or_null(transitions[event])
		if state == null:
			continue
		hsm.add_transition(self, state, event)

func _enter() -> void:
	TurnManager.new_turn.emit()
	TurnManager.player_turn.emit()
	TurnManager.turn_counter += 1

func _update(delta: float) -> void:
	if Global.player == null:
		dispatch(EVENT_FINISHED)
		return
	
	if Global.player.actionable or Global.player.busy:
		return
	
	if TurnManager.is_any_entity_actionable() or TurnManager.is_any_entity_busy():
		return
	
	dispatch(EVENT_FINISHED)

func _exit() -> void:
	var all_entities: Array = get_tree().get_nodes_in_group("entity")
	
	for entity: Entity in all_entities:
		entity.actionable = false
		entity.busy = false
