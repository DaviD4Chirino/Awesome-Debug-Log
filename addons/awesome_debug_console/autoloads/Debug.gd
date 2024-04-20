extends CanvasLayer
## THe maximum amount of logs before they get freed (keep it low)
@export var max_logs: int = 30

@export_group("Nodes")
@export var debug_panel: PanelContainer
@export var logs_container: VBoxContainer
@export var log_scene: PackedScene
var t: float = 0.0
func _ready():
	self.log("Vector", Vector2.LEFT)

func _process(delta):
	self.log("FPS", Engine.get_frames_per_second())

func _input(event: InputEvent):
	# shift + Tab
	# we use already made actions because theres not a function
	# to add events in the editor, and i dont want to write it myself so
	# this will do for now
	## Replace it with whatever you want
	if event.is_action_released(&"ui_text_dedent"):
		# Toggle the panel
		debug_panel.visible = !debug_panel.visible

func log(title: String, value: Variant):

	# If theres a log with the same name we just update that, 
	# else we create a new one
	var existing_log: Control = _log_exist(title)

	if existing_log:
		existing_log.title = title
		existing_log.value = value
		return

	var new_log: HBoxContainer = _create_log(title, value)
	logs_container.add_child(new_log)
	pass

func _create_log(title: String, value: Variant):
	var new_log: HBoxContainer = log_scene.instantiate()
	new_log.title = title
	new_log.value = value
	return new_log

func _log_exist(title: String) -> Control:
	for log in logs_container.get_children():
		if log.title == title:
			return log
	return null

func _on_log_container_child_entered_tree(node: Node) -> void:
	if logs_container.get_child_count() > max_logs:
		logs_container.get_child(0).queue_free()
	pass # Replace with function body.
