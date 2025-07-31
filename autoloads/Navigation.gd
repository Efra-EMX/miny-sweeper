extends Node

@onready var grid: AStarGrid2D = AStarGrid2D.new()

#func _ready() -> void:
	#update_grid()

func update_grid() -> void:
	if Global.terrain == null:
		return
	
	grid = AStarGrid2D.new()
	grid.region = Global.terrain.base_tilemap.get_used_rect()
	grid.cell_size = Vector2.ONE * Global.terrain.tile_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()
	
	for coords in Global.terrain.wall_tilemap.get_used_cells():
		grid.set_point_solid(coords)
	
	for entity in get_tree().get_nodes_in_group("entity"):
		if entity == null:
			continue
		if entity is not Entity:
			continue
		grid.set_point_solid(entity.coords)

func get_next_path(origin: Vector2i, target: Vector2i) -> Vector2i:
	update_grid()
	return grid.get_id_path(origin, target, true)[1]
	
func get_grid_path(origin: Vector2i, target: Vector2i) -> Array[Vector2i]:
	update_grid()
	return grid.get_id_path(origin, target, true)
