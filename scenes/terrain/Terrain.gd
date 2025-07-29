extends Node2D
class_name Terrain

static var base_tilemap: TileMapLayer

@export var chunk_size: Vector2i = Vector2i(8, 8)
@export var bomb_count: int = 10

@export var floor_tilemap: TileMapLayer
@export var bomb_tilemap: TileMapLayer
@export var wall_tilemap: TileMapLayer
@export var label_tilemap: TileMapLayer
@onready var started: bool = false

var bomb_atlas_coords = Vector2i(1, 0)
#var bomb_bitmap: BitMap
#var wall_bitmap: BitMap

const tile_size: int = 24

var loaded_chunks: Array[Vector2i]

func _ready() -> void:
	#Global.terrain = self
	base_tilemap = floor_tilemap

func generate_chunk(chunk_coords: Vector2i, empty_tiles: Array[Vector2i] = []) -> void:
	if loaded_chunks.has(chunk_coords):
		return
	
	for coords:Vector2i in get_coords_in_chunk(chunk_coords):
		#set_bomb(coords, bomb_array[coords.x + (coords.y * chunk_size.x)])
		set_wall(coords, true)
	
	var bomb_array: Array[bool]
	bomb_array.resize(bomb_count)
	bomb_array.fill(true)
	bomb_array.resize((chunk_size.x * chunk_size.y) - empty_tiles.size())
	bomb_array.shuffle()
	
	#var array_size: int = bomb_array.size()
	for index in bomb_array.size():
		index = (chunk_size.x * chunk_size.y) - (index + 1)
		
		var x: int = index % chunk_size.x
		var coords: Vector2i = Vector2i(x, (index - x) / chunk_size.x) + (chunk_coords * chunk_size)
		
		if empty_tiles.has(coords):
			continue
		set_bomb(coords, bomb_array.pop_back())
		
	loaded_chunks.append(chunk_coords)
	if not started:
		started = true

func get_coords_in_chunk(chunk_coords: Vector2i) -> Array[Vector2i]:
	var all_coords: Array[Vector2i]
	for x in chunk_size.x:
		for y in chunk_size.y:
			all_coords.append(Vector2i(x, y) + (chunk_coords * chunk_size))
	return all_coords

func coords_to_chunk_coords(coords: Vector2) -> Vector2i:
	return floor(coords / Vector2(chunk_size))

func position_to_chunk_coords(position: Vector2) -> Vector2i:
	return coords_to_chunk_coords(position_to_coords(position))

func position_to_coords(position: Vector2) -> Vector2i:
	return base_tilemap.local_to_map(base_tilemap.to_local(position))

func coords_to_position(coords: Vector2i) -> Vector2:
	return base_tilemap.to_global(base_tilemap.map_to_local(coords))

func is_tile_loaded(coords: Vector2i) -> bool:
	return loaded_chunks.has(coords_to_chunk_coords(coords))
	
func set_bomb(coords: Vector2i, value: bool) -> void:
	if value:
		bomb_tilemap.set_cell(coords, 1, bomb_atlas_coords)
	else:
		bomb_tilemap.set_cell(coords)
	
	#if is_tile_revealed(coords):
		#return
	
	#for nearby_coords in get_nearby_coords(coords):
		#if is_tile_revealed(nearby_coords):
			#update_label(nearby_coords)

func set_wall(coords: Vector2i, value: bool) -> void:
	if value:
		wall_tilemap.set_cell(coords, 0, Vector2i(0,1))
		return
	wall_tilemap.set_cell(coords)
	floor_tilemap.set_cell(coords, 0, Vector2i(1,0))
	
#func update_bombs_batch() -> void:
	#for coords:Vector2i in all_coords:
		#if bomb_bitmap.get_bitv(coords):
			#bomb_tilemap.set_cell(coords, 1, bomb_atlas_coords)
			#continue
		#bomb_tilemap.set_cell(coords)

func update_label_batch(chunk_coords: Vector2i) -> void:
	for coords:Vector2i in get_coords_in_chunk(chunk_coords):
		if is_tile_has_bomb(coords):
			continue
		update_label(coords)
	
func update_label(coords: Vector2i) -> void:
	if not is_tile_loaded(coords):
		return
	#if label_tilemap.get_cell_source_id(coords) >= 0:
		#if not is_tile_has_bomb_nearby(coords):
			#var tile_data: TileData = label_tilemap.get_cell_tile_data(coords)
			#if tile_data != null:
				#tile_data.modulate = Color(1, 1, 1, 0.5)
		#return
	
	if is_tile_has_bomb(coords):
		label_tilemap.set_cell(coords, 1, bomb_atlas_coords)
		return
		
	var bombs: int = get_nearby_bomb_count(coords)
	if bombs > 0:
		label_tilemap.set_cell(coords, 0, Vector2i(bombs, 0))
		return
	label_tilemap.set_cell(coords)

func get_nearby_coords(coords: Vector2i) -> Array:
	return Global.direction_vectors.values().map(func(value: Vector2i): return value + coords)

func get_nearby_bomb_count(coords: Vector2i) -> int:
	var bombs: int = 0
	for direction:Vector2i in Global.direction_vectors.values():
		if is_tile_has_bomb(coords + direction):
			bombs += 1
	return bombs

func is_tile_has_bomb(coords: Vector2i) -> bool:
	if bomb_tilemap.get_cell_source_id(coords) >= 0:
		return true
	return false

func is_tile_has_bomb_nearby(coords: Vector2i) -> bool:
	for direction:Vector2i in Global.direction_vectors.values():
		if is_tile_has_bomb(coords + direction):
			return true
	return false

func is_tile_revealed(coords: Vector2i) -> bool:
	if wall_tilemap.get_cell_source_id(coords) < 0:
		return true
	return false

func chain_reveal(coords: Vector2i) -> void:
	if is_tile_revealed(coords):
		return
	
	reveal(coords)
	
	if is_tile_has_bomb_nearby(coords) or is_tile_has_bomb(coords):
		return
	
	for neighbor_coords in get_nearby_coords(coords):
		chain_reveal(neighbor_coords)

func reveal(coords: Vector2i) -> void:
	#set_bomb(coords, false)
	
	for neighbor_coords in get_nearby_coords(coords):
		if not is_tile_loaded(neighbor_coords):
			generate_chunk(coords_to_chunk_coords(neighbor_coords))
	
	set_wall(coords, false)
	update_label(coords)

func toggle_flag(coords: Vector2i) -> void:
	if is_tile_revealed(coords):
		return
	if label_tilemap.get_cell_source_id(coords) < 0:
		label_tilemap.set_cell(coords, 1, Vector2i(2,0))
		return
	label_tilemap.set_cell(coords)

func move_to(node: Node2D, coords: Vector2i, time = 0.2) -> Tween:
	var tween: Tween = node.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var target_position: Vector2 = base_tilemap.to_global(base_tilemap.map_to_local(coords))
	tween.tween_property(node, "global_position", target_position, time)
	return tween

func bounce_to(node: Node2D, coords: Vector2i, time = 0.2) -> Tween:
	var tween = node.create_tween().set_trans(Tween.TRANS_QUAD)
	var original_position: Vector2 = node.global_position
	var target_position: Vector2 = base_tilemap.to_global(base_tilemap.map_to_local(coords))
	var bounce_direction: Vector2 = original_position.direction_to(target_position) * (base_tilemap.tile_set.tile_size as Vector2 / 2)
	
	tween.tween_property(node, "global_position", original_position + bounce_direction, time/2).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "global_position", original_position, time/2).set_ease(Tween.EASE_IN)
	
	return tween

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			return
		
		var mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
		var coords: Vector2i = base_tilemap.local_to_map(base_tilemap.to_local(mouse_position))
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not is_tile_loaded(coords):
				if started:
					generate_chunk(coords_to_chunk_coords(coords))
				else:
					var empty_tiles: Array[Vector2i] = [coords]
					empty_tiles.append_array(get_nearby_coords(coords))
					
					generate_chunk(coords_to_chunk_coords(coords), empty_tiles)
			chain_reveal(coords)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag(coords)
