extends Node

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	get_viewport().gui_focus_changed.connect(on_focus_changed)

func _process(_delta: float) -> void:
	if Page.current_page == null:
		return
	var control: Control = get_viewport().gui_get_hovered_control()
	if !control:
		return
	if Page.current_page.is_ancestor_of(control) && control.focus_mode != 0:
		control.grab_focus()

func on_focus_changed(node: Control) -> void:
	if node == null:
		return
	print("Current focus = ", node.name)
	if AudioManager.is_playing(&"confirm") || AudioManager.is_playing(&"cancel"):
		return
	AudioManager.play(&"select")
