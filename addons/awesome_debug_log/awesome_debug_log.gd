@tool
extends EditorPlugin

func _enter_tree() -> void:
	InputMap.add_action(&"DEBUG_ACTION_TOGGLE_CONSOLE")
	# InputMap.action_add_event(&"DEBUG_ACTION_TOGGLE_CONSOLE",)

	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
