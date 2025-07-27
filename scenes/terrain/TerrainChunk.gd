extends Node2D

@export var size: Vector2i = Vector2i(32, 32)
@export var bomb_count: int = 10

@onready var bomb_tilemap: TileMapLayer = $BombTileMap
@onready var number_tilemap: TileMapLayer = $NumberTileMap
@onready var wall_tilemap: TileMapLayer = $WallTileMap
@onready var started: bool = false

var bomb_atlas_coords = Vector2i(1, 0)
#var bomb_bitmap: BitMap
#var wall_bitmap: BitMap

const direction_vectors: Dictionary[StringName, Vector2i] = {
	&"Right"		: Vector2i.RIGHT,
	&"Left"			: Vector2i.LEFT,
	&"Up"			: Vector2i.UP,
	&"Down"			: Vector2i.DOWN,
	&"UpLeft"		: Vector2i(-1, -1),
	&"UpRight"		: Vector2i(1, -1),
	&"DownLeft"		: Vector2i(-1, 1),
	&"DownRight"	: Vector2i(1, 1)
}

var all_coords: Array[Vector2i]

func _ready() -> void:
	for x in size.x:
		for y in size.y:
			all_coords.append(Vector2i(x, y))
	#generate_chunk()

func generate_chunk(empty_tiles: Array[Vector2i] = []) -> void:
	var bomb_array: Array[bool]
	bomb_array.resize(bomb_count)
	bomb_array.fill(true)
	bomb_array.resize((size.x * size.y) - empty_tiles.size())
	bomb_array.shuffle()
	
	#var array_size: int = bomb_array.size()
	for index in bomb_array.size():
		index = (size.x * size.y) - (index + 1)
		
		var x: int = index % size.x
		var coords: Vector2i = Vector2i(x, (index - x) / size.x)
		
		if empty_tiles.has(coords):
			continue
		set_bomb(coords, bomb_array.pop_back())
		
	for coords:Vector2i in all_coords:
		#set_bomb(coords, bomb_array[coords.x + (coords.y * size.x)])
		set_wall(coords, true)
	
	#update_number_batch()

func set_bomb(coords: Vector2i, value: bool) -> void:
	if value:
		bomb_tilemap.set_cell(coords, 1, bomb_atlas_coords)
		return
	bomb_tilemap.set_cell(coords)

func set_wall(coords: Vector2i, value: bool) -> void:
	if value:
		wall_tilemap.set_cell(coords, 0, Vector2i(0,1))
		return
	wall_tilemap.set_cell(coords)
	
#func update_bombs_batch() -> void:
	#for coords:Vector2i in all_coords:
		#if bomb_bitmap.get_bitv(coords):
			#bomb_tilemap.set_cell(coords, 1, bomb_atlas_coords)
			#continue
		#bomb_tilemap.set_cell(coords)

func update_number_batch() -> void:
	for coords:Vector2i in all_coords:
		if is_tile_has_bomb(coords):
			continue
		update_number(coords)
	
func update_number(coords: Vector2i) -> void:
	if not is_tile_has_bomb(coords):
		var bombs: int = get_nearby_bomb_count(coords)
		if bombs > 0:
			number_tilemap.set_cell(coords, 0, Vector2i(bombs, 0))
			return
	number_tilemap.set_cell(coords)

func get_nearby_bomb_count(coords: Vector2i) -> int:
	var bombs: int = 0
	for direction:Vector2i in direction_vectors.values():
		if is_tile_has_bomb(coords + direction):
			bombs += 1
	return bombs

func is_tile_has_bomb(coords: Vector2i) -> bool:
	if bomb_tilemap.get_cell_source_id(coords) >= 0:
		return true
	return false

func is_tile_has_bomb_nearby(coords: Vector2i) -> bool:
	for direction:Vector2i in direction_vectors.values():
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
	
	for neighbor_coords in wall_tilemap.get_surrounding_cells(coords):
		chain_reveal(neighbor_coords)

func reveal(coords: Vector2i) -> void:
	set_wall(coords, false)
	update_number(coords)

func toggle_flag(coords: Vector2i) -> void:
	if is_tile_revealed(coords):
		return
	if number_tilemap.get_cell_source_id(coords) < 0:
		number_tilemap.set_cell(coords, 1, Vector2i(2,0))
		return
	number_tilemap.set_cell(coords)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			return
		
		var mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
		var coords: Vector2i = wall_tilemap.local_to_map(wall_tilemap.to_local(mouse_position))
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not started:
				var empty_tiles: Array[Vector2i] = [coords]
				
				for direction in direction_vectors.values():
					if empty_tiles.has(coords+direction):
						continue
					empty_tiles.append(coords+direction)
				generate_chunk(empty_tiles)
				started = true
			chain_reveal(coords)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag(coords)
