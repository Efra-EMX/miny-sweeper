extends Node2D
class_name Stage

func _enter_tree() -> void:
	Global.stage = self
	Global.terrain = $Terrain
	Global.player = $Miny

func _ready() -> void:
	var empty_tiles: Array[Vector2i] = [Global.player.coords]
	empty_tiles.append_array(Global.terrain.get_nearby_coords(Global.player.coords))
	
	Global.terrain.generate_chunk(Global.terrain.coords_to_chunk_coords(Global.player.coords), empty_tiles)
	Global.terrain.chain_reveal(Global.player.coords)
	TurnManager.start.call_deferred()

func _physics_process(delta: float) -> void:
	print_debug(TurnManager.get_active_state())
	
	if not TurnManager.is_running():
		return
	
	if Global.player == null:
		TurnManager.stop()
		return
	
	if Global.player.stats_component == null:
		return
	
	if Global.player.stats_component.is_alive():
		return
	
	TurnManager.stop()
