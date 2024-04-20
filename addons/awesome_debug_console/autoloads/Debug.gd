extends CanvasLayer
@export var logs_cap: int = 30

@export_group("Nodes")
# @export var debug_panel: PanelContainer
# @export var logs_container: VBoxContainer
@export var tabs: TabContainer
@export var log_scene: PackedScene
var t: float = 0.0
func _ready():
	self.log("Vector", InputEventMouseButton.new())

func _process(delta):
	t += delta
	self.log("FPS", Engine.get_frames_per_second())
	self.log("Time Elapsed", t)

func _input(event: InputEvent):
	# shift + Tab
	# we use already made actions because theres not a function
	# to add events in the editor, and i dont want to write it myself so
	# this will do for now
	## Replace it with whatever you want
	if event.is_action_released(&"ui_text_dedent"):
		# Toggle the whole screen
		visible = !visible

	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_F1:
			self.log("Tab1")

func log(
	title: String,
	value: Variant=null,
	## The tab to add the log, it must exist.
	## Remember to use create_tab first
	tab: int=1,
	## If this is set to false, it will create a new log without looking for pere-existing logs
	unique: bool=true
):
	var target_tab = get_tab(tab)
	# If theres a log with the same name we just update that, 
	# else we create a new one
	var existing_log: Control = _log_exist(title)

	if unique and existing_log:
		existing_log.title = title
		existing_log.value = value
		return

	var log_container: Control = target_tab.log_container
	var new_log: HBoxContainer = _create_log(title, value)
	log_container.add_child(new_log)

	# Move the log
	# var children_count: int = log_container.get_child_count()
	# var to_index: int = children_count if position < 0 else position
	# to_index = clampi(to_index, -1, children_count)

	# if to_index == new_log.get_index():
	# 	return
	# log_container.move_child(new_log, to_index)

func create_tab():
	print(
		"""create_debug_tab():
		TODO:
			ADD A CREATION TAB TOOL
		"""
		)

func _create_log(title: String, value: Variant):
	var new_log: HBoxContainer = log_scene.instantiate()
	new_log.title = title
	new_log.value = value
	return new_log

func _log_exist(title: String, tab: int=0) -> Control:
	var target_tab: Node = get_tab(tab)
	for log in target_tab.log_container.get_children():
		if log.title == title:
			return log
	return null

## By law the only child´s of the tabs are a packed scene called tab
func get_tab(index: int=0) -> Node:
	return tabs.get_child(clampi(index, 0, tabs.get_child_count() - 1))
