extends TextureRect

@export var stats_name: StringName

func _physics_process(delta: float) -> void:
	update()

func update() -> void:
	if Global.player == null:
		#size.x = 0
		hide()
		return
	if Global.player.stats_component == null:
		#size.x = 0
		hide()
		return
	if Global.player.stats_component.get(stats_name) <= 0:
		hide()
		return
	
	size.x = Global.player.stats_component.get(stats_name) * texture.get_width()
	show()
