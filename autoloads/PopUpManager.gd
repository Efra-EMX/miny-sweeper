extends CanvasLayer

var spawn_range := Vector2i(8, 2)

func _ready() -> void:
	layer = 99
	follow_viewport_enabled = true

func pop_text(text, global_pos: Vector2, color: Color = Color.WHITE) -> void:
	var label := Label.new()
	
	add_child(label)
	label.text = str(text)
	label.modulate = color
	label.z_index = 5
	label.visible = false
	label.label_settings = preload("res://assets/ui/themes/Axial/label-default.tres")
	await get_tree().process_frame
	label.visible = true
	label.global_position = global_pos - (label.size / 2)
	label.position += Vector2(randi_range(-spawn_range.x, spawn_range.x), randi_range(-spawn_range.y, spawn_range.y))
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(label, "position", label.position+Vector2(0, -16), 0.5)
	tween.tween_callback(label.queue_free)
