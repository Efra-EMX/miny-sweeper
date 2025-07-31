extends Node

var buffer_list: Array[Buffer]

class Buffer:
	var action: Callable
	var condition: Callable
	var invert_condition: bool
	var timeout: int
	var time_stamp: int
	
	func _init(action: Callable, condition: Callable, invert_condition: bool = false, timeout: int = 150) -> void:
		self.action = action
		self.condition = condition
		self.invert_condition = invert_condition
		self.timeout = timeout
		self.time_stamp = Time.get_ticks_msec()
	
	func is_expired() -> bool:
		return Time.get_ticks_msec()-time_stamp > timeout
		
	func attempt_call() -> bool:
		if condition.get_object() == null:
			return false
		if condition.call() != invert_condition:
			action.call()
			return true
		return false

func _physics_process(_delta: float) -> void:
	var index: int = 0
	for buffer in buffer_list:
		if !buffer:
			index += 1
			continue
		if buffer.is_expired():
			buffer_list[index] = null
			index += 1
			continue
		if buffer.attempt_call():
			buffer_list[index] = null
		index += 1
	buffer_list = buffer_list.filter(filter_null)

func add(action: Callable, condition: Callable, invert_condition: bool = false, timeout: int = 150) -> void:
	if condition.call() != invert_condition:
		action.call()
		return
	
	var buffer = Buffer.new(action, condition, invert_condition, timeout)
	#var index: int = buffer_list.find(null):uwo
	#if index >= 0:
		#buffer_list[index] = buffer
		#return
	buffer_list.append(buffer)

func filter_null(value:Buffer) -> bool:
	return value != null
