extends BTState
class_name GenericBTState

@export var transitions: Dictionary = {
	&"success": NodePath(),
	&"failure": NodePath()
}

@onready var hsm: LimboHSM = get_root()

func _ready() -> void:
	for event:StringName in transitions:
		var state: LimboState = get_node_or_null(transitions[event])
		if state == null:
			continue
		hsm.add_transition(self, state, event)
