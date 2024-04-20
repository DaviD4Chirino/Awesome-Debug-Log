extends CanvasLayer
@export var debug_panel: PanelContainer
@export var logs_container: VBoxContainer
@export var log_scene: PackedScene

func _ready():
	self.log("Vector", Vector2.LEFT)

func _process(delta):
	self.log("Delta", delta)

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
	var new_log: HBoxContainer = _create_log(title, value)
	logs_container.add_child(new_log)
	pass

func _create_log(title: String, value: Variant):
	var new_log: HBoxContainer = log_scene.instantiate()
	new_log.title = title
	new_log.value = value
	return new_log

func _get_logs() -> Array[Node]:
	return logs_container.get_children()
