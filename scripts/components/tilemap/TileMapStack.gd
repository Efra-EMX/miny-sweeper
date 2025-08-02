extends TileMapLayer

@export var stack_count: int = 4
@export var stack_height: float = 0.2

var target_tilemaps: Array[TileMapLayer]

func _ready() -> void:
	var initial_layer: int = 0
	
	if get_parent() is CanvasLayer:
		get_parent().layer = - (stack_count)
		initial_layer = get_parent().layer
		
	for index in stack_count:
		index = index + 1
		
		var i: float = (index * (1 as float / stack_count))
		
		var new_canvas_layer: CanvasLayer = CanvasLayer.new()
		new_canvas_layer.layer = initial_layer + index
		new_canvas_layer.follow_viewport_enabled = true
		new_canvas_layer.follow_viewport_scale = 1 + (i * stack_height)
		add_child(new_canvas_layer)
		
		var new_tilemap: TileMapLayer = TileMapLayer.new()
		new_tilemap.tile_set = tile_set
		
		new_tilemap.modulate = Color(1-i, 1-i, 1-i)
		new_canvas_layer.add_child(new_tilemap)
		
		target_tilemaps.append(new_tilemap)

#func _physics_process(delta: float) -> void:
	#var chunk_coords: Vector2i = Global.terrain.position_to_chunk_coords(Global.camera.global_position)
	#
	#for chunk in Global.terrain.get_nearby_coords(chunk_coords) + [chunk_coords]:
		#if not Global.terrain.loaded_chunks.has(chunk):
			#Global.terrain.generate_chunk(chunk)

func _update_cells(coords: Array[Vector2i], forced_cleanup: bool) -> void:
	for tilemap in target_tilemaps:
		if tilemap == null:
			continue
		#tilemap.set_cells_terrain_connect(coords, 0, 0)
		#tilemap.clear()
		for tile in coords:
			if get_cell_source_id(tile) < 0:
				tilemap.set_cell(tile)
				continue
			tilemap.set_cells_terrain_connect([tile], 0, 0)
	#for tilemap in target_tilemaps:
		#if tilemap == null:
			#continue
		#for tile in coords:
			#tilemap.set_cell(tile, get_cell_source_id(tile), get_cell_atlas_coords(tile))
