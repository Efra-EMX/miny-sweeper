extends Button

@export var nodes: Array[Node]

func _ready():
	pressed.connect(on_button_pressed)
	mouse_entered.connect(func(): AudioManager.play(&"select"))

func on_button_pressed():
	AudioManager.play("confirm")
	for node in nodes:
		if &"visible" in node:
			node.visible = not node.visible
