extends LimboState
class_name GenericState

@export var transitions: Dictionary = {
	&"finished": NodePath()
}
@export var timeout: float = 0

@export_group("Animation")
@export var animation_player: AnimationPlayer
@export var animation_name: StringName
@export var finish_state: bool

@onready var hsm: LimboHSM = get_root()

var timer: float = 0

func _ready() -> void:
	for event:StringName in transitions:
		var state: LimboState = get_node_or_null(transitions[event])
		if state == null:
			continue
		hsm.add_transition(self, state, event)

func _enter() -> void:
	if timeout > 0:
		timer = timeout
	
	if animation_player == null:
		return
		
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)
		if finish_state:
			await animation_player.animation_finished
			if hsm.get_active_state() != self:
				return
			dispatch(EVENT_FINISHED)

func _update(delta: float) -> void:
	if timeout <= 0:
		return
	if timer <= 0:
		dispatch(EVENT_FINISHED)
		return
	timer -= delta
