extends LimboHSM
class_name GenericHSM

@export var target_agent: Node
@export var anystate_transitions: Dictionary

func _ready() -> void:
	for event:StringName in anystate_transitions:
		var state: LimboState = get_node_or_null(anystate_transitions[event])
		if state == null:
			continue
		add_transition(ANYSTATE, get_node(anystate_transitions[event]), event)
	
	initialize.call_deferred(target_agent)
	set_active.call_deferred(true)
