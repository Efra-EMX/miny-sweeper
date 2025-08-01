extends Control

var previous_page: Page

func _ready() -> void:
	get_tree().paused = false
	visible = get_tree().paused

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		pause()

func pause() -> void:
	if TurnManager.get_active_state().name == "Idle":
		return
		
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	AudioManager.play("confirm")
	print_debug("Pause status = ", get_tree().paused)
	if get_tree().paused:
		previous_page = Page.current_page
		Page.current_page = $"Panel/Pause Menu"
		return
	if previous_page != null:
		Page.current_page = previous_page
		return
	Page.current_page = null
