extends Node2D
class_name Stage

func _enter_tree() -> void:
	Global.stage = self
	Global.terrain = $Terrain
	Global.player = $Miny
