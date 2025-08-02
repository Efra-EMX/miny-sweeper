extends GenericState

#var base_cooldown: int = 1
#var cooldown: int = 1

func _enter() -> void:
	if Global.player == null:
		dispatch(EVENT_FINISHED)
		return
	
	#if cooldown > 0:
		#cooldown -= 1
		#dispatch(EVENT_FINISHED)
		#return
	
	agent.actionable = false
	agent.busy = true
	
	var path: Array[Vector2i] = Navigation.get_grid_path(agent.coords, Global.player.coords)
	
	if path.size() > 1:
		agent.movement_component.move(path[1])
	else:
		for coords in Global.terrain.base_tilemap.get_surrounding_cells(agent.coords):
			var target_entity: Entity = Entity.get_entity_on_coords(coords)
			if target_entity != null:
				if target_entity == Global.player:
					await Global.terrain.bounce_to(agent, target_entity.coords).finished
					target_entity.take_hit(AttackData.new(1, agent))
	super._enter()
	
	#cooldown = base_cooldowna
	dispatch(EVENT_FINISHED)
