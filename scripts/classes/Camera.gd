extends Camera2D
class_name Camera

@export var target_list: Array[Node2D]

var following = true
var dragging: bool = false:
	set(value):
		dragging = value
		
		if dragging:
			following = false

func _ready() -> void:
	position = get_center_point()
	await get_tree().process_frame
	Global.player.movement_component.moving.connect(on_target_moved)

func _process(_delta: float) -> void:
	if following:
		global_position = lerp(global_position, get_center_point(), 0.2)

func get_center_point() -> Vector2:
	if target_list.has(null):
		target_list = target_list.filter(func(element): return element != null)
	
	if target_list.is_empty():
		printerr("Camera target_list is empty")
		return Vector2.ZERO
	
	if target_list.size() == 1:
		if target_list[0] == null:
			return global_position
		return target_list[0].global_position
	
	var target_point: Vector2 = target_list[0].global_position
	var index: int = 1
	while index < target_list.size():
		target_point += (target_list[index].global_position - target_point) / 2
		index += 1
	
	return target_point

var tween: Tween
func shake(strength: float = 4) -> void:
	var original_offset: Vector2 = offset
	
	if tween:
		tween.kill()
	tween = create_tween()
	var direction: Vector2 = Vector2(1,0).rotated(randf())
	while strength > 1:
		tween.tween_property(self, "offset", original_offset + (direction*strength), 0)
		tween.tween_interval(0.05)
		strength = lerpf(strength, 0, 0.5)
		direction = -direction
	tween.tween_property(self, "offset", original_offset, 0)

func set_target_list(nodes: Array[Node2D]) -> void:
	for node in nodes:
		if node != null:
			target_list.append(node)
	
func clear_target_list() -> void:
	target_list.clear()

func on_target_moved() -> void:
	following = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			return
		
		if event.pressed:
			return
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(0.1 ,0.1)
			return
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(0.1 ,0.1)
			return
		
		var mouse_position: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
		var coords: Vector2i = Global.terrain.base_tilemap.local_to_map(Global.terrain.base_tilemap.to_local(mouse_position))
		
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if not Global.terrain.is_tile_loaded(coords):
				#if Global.terrain.started:
					#Global.terrain.generate_chunk(Global.terrain.coords_to_chunk_coords(coords))
				#else:
					#var empty_tiles: Array[Vector2i] = [coords]
					#empty_tiles.append_array(Global.terrain.get_nearby_coords(coords))
					#
					#Global.terrain.generate_chunk(Global.terrain.coords_to_chunk_coords(coords), empty_tiles)
			#Global.terrain.break_tile(coords)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			Global.terrain.toggle_flag(coords)
		return
	if event is InputEventMouseMotion and dragging:
		position = position - (event.relative / zoom)
