extends CanvasLayer
## The maximum amount of logs for each tab
@export var logs_cap: int = 10

@export_group("Nodes")
# @export var debug_panel: PanelContainer
# @export var logs_container: VBoxContainer
@export var tabs: TabContainer
@export var log_scene: PackedScene
@export var tab_scene: PackedScene

var t: float = 0.0

func _ready():
	self.add_tab("Log")

	tabs.current_tab = 0

func _process(delta):
	t += delta
	self.log("FPS", Engine.get_frames_per_second(), 0)
	self.log("Time Elapsed", t, 0)

func _input(event: InputEvent):
	# shift + Tab
	# we use already made actions because theres not a function
	# to add events in the editor, and i dont want to write it myself so
	# this will do for now
	## Replace it with whatever you want
	if event is InputEventKey and event.is_released():
		match event.keycode:
			# Toggle the whole screen
			KEY_F1:
				visible = !visible

			## Switch between tabs by pressing F1 and F2
			KEY_F2:
				tabs.select_previous_available()
			KEY_F3:
				tabs.select_next_available()
			
func log(
	title: String,
	value: Variant=null,
	## The tab to add the log, indexed, it must exist.
	## Remember to use add_tab first
	tab: int=0,
	## If this is set to false, it will create a new log without looking for pere-existing logs
	unique: bool=true
):
	var target_tab = _get_tab(tab)
	# If theres a log with the same name we just update that, 
	# else we create a new one
	var existing_log: Control = _log_exist(title, tab)

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

func add_tab(
	tab_name: String,
	## Where you want the tab to be
	position: int=tabs.get_child_count()
):
	var new_tab: Control = tab_scene.instantiate()
	new_tab.name = tab_name
	new_tab.logs_cap = logs_cap
	
	tabs.add_child(new_tab)

	tabs.move_child(new_tab, position)

func _create_log(title: String, value: Variant):
	var new_log: HBoxContainer = log_scene.instantiate()
	new_log.title = title
	new_log.value = value
	return new_log

func _log_exist(title: String, tab: int=0) -> Control:
	var target_tab: Node = _get_tab(tab)
	for log in target_tab.log_container.get_children():
		if log.title == title:
			return log
	return null

## By law the only child´s of the tabs are a packed scene called tab
func _get_tab(index: int=0) -> Node:
	return tabs.get_tab_control(clampi(index, 0, tabs.get_child_count() - 1))
