extends TileMapLayer

@export var stack_count: int = 4
@export var stack_height: float = 0.2

var target_tilemaps: Array[TileMapLayer]

func _ready() -> void:
	for index in stack_count:
		index = index + 1
		
		var i: float = (index * (1 as float / stack_count))
		
		var new_canvas_layer: CanvasLayer = CanvasLayer.new()
		new_canvas_layer.layer = index
		new_canvas_layer.follow_viewport_enabled = true
		new_canvas_layer.follow_viewport_scale = 1 + (i * stack_height)
		add_child(new_canvas_layer)
		
		var new_tilemap: TileMapLayer = TileMapLayer.new()
		new_tilemap.tile_set = tile_set
		
		new_tilemap.modulate = Color(1-i, 1-i, 1-i)
		new_canvas_layer.add_child(new_tilemap)
		
		target_tilemaps.append(new_tilemap)
		
func _update_cells(coords: Array[Vector2i], forced_cleanup: bool) -> void:
	for tilemap in target_tilemaps:
		if tilemap == null:
			continue
		for tile in coords:
			tilemap.set_cell(tile, get_cell_source_id(tile), get_cell_atlas_coords(tile))
