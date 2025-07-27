@tool
extends BTAction
class_name BTPlaySFX

@export var sfx_name: StringName

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	var new_name: String = "PlaySFX "
	if sfx_name != "":
		new_name += str("\"", sfx_name, "\"")
	return new_name

# Called when the task is entered.
func _enter() -> void:
	AudioManager.play(sfx_name)

func _tick(delta: float) -> Status:
	return SUCCESS
