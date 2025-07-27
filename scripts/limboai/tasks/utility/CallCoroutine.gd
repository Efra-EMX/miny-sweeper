@tool
extends BTCallMethod
class_name BTCallCoroutine

var coroutine: Callable
var await_completed: bool = false

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	var new_name: String = "CallCoroutine "
	new_name += str(method, "(")
	for arg in args:
		if arg == args[0]:
			new_name += str(arg)
			continue
		new_name += str(", ", arg)
	new_name += str(") node:", node, " ")
	if result_var != "":
		new_name += str("->", result_var)
	return new_name

# Called to initialize the task.
func _setup() -> void:
	pass

# Called when the task is entered.
func _enter() -> void:
	await_completed = false
	
	if coroutine == null:
		coroutine = Callable(node.get_value(scene_root, blackboard), method)
	
	if result_var:
		var result = await coroutine.callv(args.map(map_args))
		blackboard.set_var(result_var, result)
	else:
		await coroutine.callv(args.map(map_args))
	
	await_completed = true

func map_args(value: BBVariant):
	return value.get_value(scene_root, blackboard)

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if !await_completed:
		return RUNNING
	return SUCCESS
