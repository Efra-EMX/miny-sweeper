extends Character

var range_radius: float = 2

func _ready() -> void:
	super._ready()

func is_tile_within_range(tile_coords: Vector2i) -> bool:
	return Geometry2D.is_point_in_circle(tile_coords, coords, range_radius)
