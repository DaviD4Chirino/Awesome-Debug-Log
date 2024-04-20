extends CanvasLayer
@export var debug_panel: PanelContainer

func _input(event: InputEvent):
	# shift + Tab
	# we use already made actions because theres not a function
	# to add events in the editor, and i dont want to write it myself so
	# this will do for now
	## Replace it with whatever you want
	if event.is_action_released(&"ui_text_dedent"):
		# Toggle the panel
		debug_panel.visible = !debug_panel.visible