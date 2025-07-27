extends Control
class_name Page

@export var active_on_ready: bool = false

static var current_page: Page:
	set(page):
		if !page:
			if current_page != null:
				current_page.deactivate()
				current_page = null
			return
		var prev_page = current_page
		current_page = page
		if prev_page != null:
			prev_page.deactivate()
		page.activate()
var previous_page: Page:
	set(page):
		if page != self:
			previous_page = page

@export var default_focus: Control
var last_focus: Control

signal activated
signal deactivated

static func switch_page(page:Page) -> void:
	if page != null && current_page != null:
		page.previous_page = current_page
	current_page = page

static func back() -> void:
	if current_page == null:
		return
	if current_page.previous_page == null:
		return
	current_page.last_focus = null
	current_page = current_page.previous_page
	
static func get_page_of(node:Control) -> Page:
	var parent = node.get_parent()
	if parent == null:
		return null
	if parent is Page:
		return parent
	return get_page_of(parent)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if active_on_ready:
		switch_page(self)
	(func(): if !is_active(): hide()).call_deferred()

func activate() -> void:
	get_viewport().gui_focus_changed.connect(update_last_focus)
	if !visible:
		show()
	if last_focus != null:
		last_focus.grab_focus()
	elif default_focus != null:
		default_focus.grab_focus()
	activated.emit()

func deactivate() -> void:
	get_viewport().gui_focus_changed.disconnect(update_last_focus)
	if not is_ancestor_of(current_page):
		hide()
	deactivated.emit()

func update_last_focus(node:Control) -> void:
	if node == null:
		last_focus = null
		return
	if is_ancestor_of(node):
		last_focus = node
		return

func is_active() -> bool:
	if current_page == self:
		return true
	return false

func _input(event: InputEvent) -> void:
	if !is_active():
		return
	#if event.is_action_pressed("ui_cancel"):
		#back()
	if get_viewport().gui_get_focus_owner():
		return
	if event.is_action_pressed(&"ui_up") \
	|| event.is_action_pressed(&"ui_down") \
	|| event.is_action_pressed(&"ui_right") \
	|| event.is_action_pressed(&"ui_left"):
		if default_focus:
			default_focus.grab_focus()
