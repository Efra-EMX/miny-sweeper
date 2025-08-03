extends Node2D
class_name Stage

var bombs_left: int:
	get():
		return Global.terrain.get_bombs_left()
var enemies_left: int:
	get():
		return Global.terrain.get_enemies_left()
var bombs_uncovered: int
var bombs_exploded: int = 0
var enemies_defeated: int = 0
var tiles_uncovered: int = 0

var endless: bool = false

func _enter_tree() -> void:
	Global.stage = self
	Global.terrain = $Terrain
	Global.player = $Miny
	
	if SceneManager.passed_data.has(&"endless"):
		if SceneManager.passed_data[&"endless"] == true:
			endless = true
			Global.terrain.bounds = Rect2i()

func _ready() -> void:
	AudioManager.play_bgm("The Third Sweeper Sister")
	
	if Global.game_running:
		Global.game_running = false
		TurnManager.stop()
		
	var empty_tiles: Array[Vector2i] = [Global.player.coords]
	empty_tiles.append_array(Global.terrain.get_nearby_coords(Global.player.coords))
	
	Global.terrain.generate_chunk(Global.terrain.coords_to_chunk_coords(Global.player.coords), empty_tiles)
	Global.terrain.chain_reveal(Global.player.coords)
	
	if SceneManager.passed_data.has(&"title"):
		if SceneManager.passed_data[&"title"] == false:
			start_game()
			return
	
	Global.camera.offset.x = - get_viewport_rect().size.x / 4
	$UI/GUI.hide()
	$TileHighlight.hide()
	$TopLabel/TileHighlight.hide()

func start_game() -> void:
	$"UI/Title Screen".queue_free()
	#Global.camera.offset.x = 0
	create_tween().tween_property(Global.camera, "offset", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	Global.game_running = true
	$UI/GUI.show()
	$TileHighlight.show()
	$TopLabel/TileHighlight.show()
	TurnManager.start.call_deferred()

func stop_game() -> void:
	Global.game_running = false
	TurnManager.stop()
	Page.switch_page($UI/GameOver)
	Global.terrain.bomb_tilemap.show()

func win_game() -> void:
	Global.game_running = false
	TurnManager.stop()
	Page.switch_page($UI/GameWon)

func get_statistics() -> String:
	var stats: String = ""
	stats += str("Turns: ", TurnManager.turn_counter, "\n")
	if not endless:
		stats += str("Bombs left: ", bombs_left, "\n")
		stats += str("Enemies left: ", enemies_left, "\n\n")
	stats += str("Bombs uncovered: ", bombs_uncovered, "\n")
	stats += str("Bombs exploded: ", bombs_exploded, "\n")
	stats += str("Enemies defeated: ", enemies_defeated, "\n")
	stats += str("Tiles uncovered: ", tiles_uncovered)
	
	return stats

func _physics_process(delta: float) -> void:
	if not Global.game_running:
		return
	
	if bombs_left <= 0 and enemies_left <= 0:
		win_game()
		return
	
	if Global.player == null:
		stop_game()
		return
	
	if Global.player.stats_component == null:
		return
	
	if Global.player.stats_component.is_alive():
		return
	
	stop_game()
