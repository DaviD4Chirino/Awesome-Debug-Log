@tool
extends EditorPlugin
## If you want the autoload to have a diferent name, 
## FIRST Deactivate the addon
## then reactive the addon
const DEBUG_AUTOLOAD_NAME = "Debug"
const DEBUG_AUTOLOAD_PATH: String = "res://addons/awesome_debug_log/autoloads/debug.tscn"

func _enter_tree() -> void:
	add_autoload_singleton(DEBUG_AUTOLOAD_NAME, DEBUG_AUTOLOAD_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(DEBUG_AUTOLOAD_NAME)
