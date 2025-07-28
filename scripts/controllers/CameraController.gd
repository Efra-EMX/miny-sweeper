extends Camera2D

var dragging: bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			return
	if event is InputEventMouseMotion and dragging:
		position = position - event.relative
