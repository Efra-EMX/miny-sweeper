extends Entity
class_name Character

@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: GenericHSM = $StateMachine
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	if is_in_group("player"):
		TurnManager.player_turn.connect(set.bind("actionable", true))
	elif is_in_group("enemy"):
		TurnManager.enemy_turn.connect(set.bind("actionable", true))
		#TurnManager.enemy_turn.connect(state_machine.dispatch.bind("act"))
	super._ready()

func interact_with(coords: Vector2i) -> void:
	super.interact_with(coords)

func on_killed() -> void:
	await get_tree().physics_frame
	if is_in_group("enemy"):
		Global.stage.enemies_defeated += 1
	if self == Global.player:
		PopUpManager.pop_text([
				"No...",
				"Big sis Eeny...",
				"I can't stop here..."
			].pick_random(), Global.terrain.coords_to_position(coords) + Vector2(0,-12))
	if state_machine.dispatch("down"):
		return
	queue_free()
