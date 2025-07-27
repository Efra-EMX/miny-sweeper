extends Node

func _enter_tree() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	get_window().always_on_top = true
	process_mode = PROCESS_MODE_ALWAYS 

func _process(_delta: float) -> void:
	if !OS.is_debug_build():
		return

func _unhandled_input(event: InputEvent) -> void:
	if !OS.is_debug_build():
		return
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
		print_debug("Scene reloaded")
