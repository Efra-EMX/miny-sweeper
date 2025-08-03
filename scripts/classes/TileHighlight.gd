extends Sprite2D

var coords: Vector2i:
	set(value):
		global_position = Global.terrain.coords_to_position(value)
	get():
		return get_coords()

func _ready() -> void:
	coords = coords

func get_coords() -> Vector2i:
	return Global.terrain.position_to_coords(global_position)

func _process(delta: float) -> void:
	var mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	coords = Global.terrain.position_to_coords(mouse_position)
	
	$BombSprite.hide()
	
	if Global.player.stats_component.mp <= 0:
		return
	if Global.player.is_tile_within_range(get_coords()):
		$BombSprite.show()
