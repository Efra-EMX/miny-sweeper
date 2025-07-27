extends RichTextLabel

@export_enum("left", "center", "right") var alignment: String = "left"

func _ready() -> void:
	text = "[%s]Version %s" % [alignment, ProjectSettings.get("application/config/version")]
