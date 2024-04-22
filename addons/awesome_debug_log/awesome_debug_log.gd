@tool
extends EditorPlugin
## If you want the autoload to have a diferent name, 
## FIRST Deactivate the addon
## then reactive the addon
const DEBUG_AUTOLOAD_NAME = "Debug"
const DEBUG_AUTOLOAD_PATH: String = "res://addons/awesome_debug_log/autoloads/debug.tscn"

# Update button
const UPDATE_BUTTON_SCENE: PackedScene = preload ("res://addons/awesome_debug_log/editor/update button/update_button.tscn")
var update_button: Button

func _enter_tree() -> void:
	add_autoload_singleton(DEBUG_AUTOLOAD_NAME, DEBUG_AUTOLOAD_PATH)
	update_button = UPDATE_BUTTON_SCENE.instantiate()
	update_button.editor_plugin = self
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, update_button)
	
func _exit_tree() -> void:
	remove_autoload_singleton(DEBUG_AUTOLOAD_NAME)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, update_button)
	update_button.queue_free()