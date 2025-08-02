extends GenericState

var target_coords: Vector2i

func _ready() -> void:
	super._ready()

func _enter() -> void:
	super._enter()
	agent.actionable = false
	agent.busy = true
	
	target_coords = agent.coords + agent.direction
	
	if Global.terrain.is_tile_revealed(target_coords):
		var target_entity: Entity = Entity.get_entity_on_coords(target_coords)
		if target_entity == null:
			#await agent.movement_component.move(target_coords)
			agent.movement_component.move(target_coords)
		elif target_entity is Character:
			%AnimationPlayer.play("Mine")
			await %AnimationPlayer.animation_finished
			target_entity.state_machine.dispatch("stun")
		else:
			await target_entity.interact(agent)
	elif Global.terrain.is_tile_flagged(target_coords):
		%AnimationPlayer.play("Mine")
		await %AnimationPlayer.animation_finished
		if Global.terrain.is_tile_has_bomb(target_coords):
			PopUpManager.pop_text("BOMB +1", Global.terrain.coords_to_position(agent.coords) + Vector2(0,-12), Color.YELLOW)
			await Global.terrain.reveal(target_coords)
			agent.stats_component.mp += 1
			AudioManager.play("confirm")
		else:
			await Global.terrain.reveal(target_coords)
			agent.busy = false
			print_debug(agent.state_machine.dispatch("stun"))
			return
	else:
		%AnimationPlayer.play("Mine")
		await %AnimationPlayer.animation_finished
		await Global.terrain.break_tile(target_coords)
		#await agent.interact_with(target_coords)
	
	agent.busy = false
	dispatch(EVENT_FINISHED)

func _update(delta: float) -> void:
	super._update(delta)
