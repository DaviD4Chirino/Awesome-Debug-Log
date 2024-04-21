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
	assert(tabs.get_tab_count() > 0, "There must be at least one tab")

func _process(delta):
	t += delta
	self.log("FPS", "%.2f" % (1.0 / delta), "", false)

func _input(event: InputEvent):
	## Replace it with whatever you want
	# I used Keycode because i don´t see how to add a custom action to the input map
	# Well, more like i don´t WANT to make a way, so I used physical keycode
	if event is InputEventKey and event.is_released():
		match event.keycode:
			# Toggle the whole screen
			KEY_F1:
				visible = !visible

			# Switch between tabs by pressing F1 and F2
			KEY_F2:
				tabs.select_previous_available()
			KEY_F3:
				tabs.select_next_available()
			
func log(
	title: String,
	value: Variant=null,
	## The tab to add the log, indexed, it must exist.
	## Remember to use add_tab first
	tab: String="",
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

func add_tab(
	tab_name: String,
	## Where you want the tab to be, less than 0 put it at the end
	at_position: int=- 1,
	## The maximum number of logs that tab can have, 
	## [b] a value of 0 means uncapped[/b]
	capped_at: int=0
):
	var new_tab: Control = tab_scene.instantiate()
	new_tab.name = tab_name
	new_tab.logs_cap = capped_at if capped_at >= 0 else logs_cap
	
	tabs.add_child(new_tab)

	tabs.move_child(
		new_tab,
		at_position if at_position >= 0 else tabs.get_tab_count()
	)

func remove_tab(tab_name: String):
	for tab_idx in tabs.get_tab_count():
		var existing_tab: Control = tabs.get_tab_control(tab_idx)
		if existing_tab.name == tab_name:
			existing_tab.queue_free()
			return

## Gets the Control node of the tab_name, if theres none prints an error and returns the first tab
func _get_tab(tab_name: String) -> Control:
	if tab_name == "":
		return tabs.get_tab_control(0)
		
	for tab_idx in tabs.get_tab_count():
		var existing_tab: Control = tabs.get_tab_control(tab_idx)
		if existing_tab.name == tab_name:
			return existing_tab
	printerr(
		"Debug Log: There´s no tab with the name of %s" % tab_name
	)
	return tabs.get_tab_control(0)

## Gets the index of a tab or -1 if theres none
func _get_tab_index(tab_name: String) -> int:
	for tab_idx in tabs.get_tab_count():
		var existing_tab: Control = tabs.get_tab_control(tab_idx)
		if existing_tab.name == tab_name:
			return tab_idx

	return - 1

func _update_tab(
	tab_name: String,
	new_tab_name: String="",
	move_to_position: int=- 1,
	caped_at: int=- 1
):
	pass

func _create_log(title: String, value: Variant):
	var new_log: HBoxContainer = log_scene.instantiate()
	new_log.title = title
	new_log.value = value
	return new_log

func _log_exist(title: String, tab: String="") -> Control:
	var target_tab: Node = _get_tab(tab)
	for log in target_tab.log_container.get_children():
		if log.title == title:
			return log
	return null
