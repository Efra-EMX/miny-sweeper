extends Entity

var exploded: bool = false

func interact(from: Entity = null) -> void:
	if exploded:
		return
	
	busy = true
	exploded = true
	#modulate = Color.RED
	await get_tree().create_timer(0.5).timeout
	
	for neighbor_coords in Global.terrain.base_tilemap.get_surrounding_cells(coords):
		interact_with(neighbor_coords)
	
	busy = false
	queue_free()

func interact_with(coords: Vector2i) -> void:
	if Global.terrain.is_tile_revealed(coords):
		var target_entity: Entity = get_entity_on_coords(coords)
		if target_entity != null:
			if target_entity is Character:
				target_entity.take_hit(AttackData.new(1, self))
			else:
				target_entity.interact(self)
	else:
		Global.terrain.break_tile(coords)
	
	await super.interact_with(coords)
