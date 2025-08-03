extends GenericState

var stun: int = 3

func _enter() -> void:
	stun = 3
	agent.modulate = Color.GRAY
	if agent.is_in_group("player"):
		stun = 1
		#TurnManager.player_turn.connect(set.bind("actionable", true))
	#elif is_in_group("enemy"):
		#TurnManager.enemy_turn.connect(on_enemy_turn)
	#TurnManager.new_turn.connect(on_new_turn)
	AudioManager.play("hurt")
	super._enter()
	await get_tree().process_frame
	agent.animation_player.play("Stunned")

func _update(delta: float) -> void:
	if agent.actionable:
		stun -= 1
		agent.actionable = false
		
		if agent == Global.player:
			agent.busy = true
			await get_tree().create_timer(0.5).timeout
			agent.busy = false
		
		if stun <= 0:
			dispatch(EVENT_FINISHED)

func on_new_turn() -> void:
	if agent.actionable:
		stun -= 1
		agent.actionable = false
		
		if agent == Global.player:
			agent.busy = true
			await get_tree().create_timer(0.5).timeout
			agent.busy = false
		
		if stun <= 0:
			dispatch(EVENT_FINISHED)

func _exit() -> void:
	agent.modulate = Color.WHITE
	#TurnManager.enemy_turn.disconnect(on_enemy_turn)
	#TurnManager.new_turn.disconnect(on_new_turn)
