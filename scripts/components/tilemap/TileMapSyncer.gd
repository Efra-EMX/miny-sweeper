extends TileMapLayer

@export var target_tilemaps: Array[TileMapLayer]

func _ready() -> void:
	for tilemap in target_tilemaps:
		tilemap.tile_set = tile_set

func _update_cells(coords: Array[Vector2i], forced_cleanup: bool) -> void:
	for tilemap in target_tilemaps:
		if tilemap == null:
			continue
		for tile in coords:
			tilemap.set_cell(tile, get_cell_source_id(tile), get_cell_atlas_coords(tile))
