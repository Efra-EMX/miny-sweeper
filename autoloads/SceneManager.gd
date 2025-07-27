extends CanvasLayer

var passed_data: Dictionary

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal scene_changing
signal scene_changed

func _enter_tree() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func transition(target_scene, data: Dictionary = {}) -> void:
	passed_data = data
	if is_transitioning():
		print_debug("Transition failed -> " + str(target_scene))
		return
	print_debug("Transitioning to -> " + str(target_scene))
	scene_changing.emit()
	animation_player.play("fade out")
	await animation_player.animation_finished
	if Page.current_page:
		Page.current_page = null
	if get_tree().paused:
		get_tree().paused = false
	if target_scene is PackedScene:
		get_tree().change_scene_to_packed(target_scene)
	elif target_scene is String:
		get_tree().change_scene_to_file(target_scene)
	elif target_scene == get_tree().current_scene:
		get_tree().reload_current_scene()
	scene_changed.emit()
	animation_player.play("fade in")
	await animation_player.animation_finished
 
func is_transitioning() -> bool:
	return animation_player.is_playing()
