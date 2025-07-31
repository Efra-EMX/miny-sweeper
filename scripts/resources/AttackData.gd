extends Resource
class_name AttackData

enum Mode {DAMAGE, HEAL}

@export var amount: int = 10
@export var mode: Mode = Mode.DAMAGE
@export var effect: PackedScene

var attacker: Entity

func _init(amount: int = 0, attacker: Entity = null, mode: int = Mode.DAMAGE, effect: PackedScene = null) -> void:
	self.amount = amount
	self.attacker = attacker
	self.mode = mode
	self.effect = effect

func execute(target: Node) -> bool:
	if !target.has_method("take_hit"):
		return false
	return target.take_hit(self)

func spawn_effect(target_entity: Entity) -> Node:
	if effect == null:
		return null
	var new_effect: Node2D = effect.instantiate()
	target_entity.get_tree().current_scene.add_child(new_effect)
	new_effect.global_position = target_entity.global_position
	return new_effect
