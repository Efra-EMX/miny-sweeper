extends Button
class_name ChangeSceneButton

@export_file("*.tscn") var target_scene: String
@export var data: Dictionary

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)

func on_pressed() -> void:
	if target_scene.is_empty():
		return
	AudioManager.play(&"confirm")
	SceneManager.transition(target_scene, data)

func on_mouse_entered() -> void:
	AudioManager.play(&"select")
