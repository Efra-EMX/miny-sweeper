extends GenericState

func _enter() -> void:
	agent.busy = false
	super._enter()

func _update(delta: float) -> void:
	#if agent.actionable:
		#dispatch("act")
	super._update(delta)
