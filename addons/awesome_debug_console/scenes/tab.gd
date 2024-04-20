extends Control
@export var child_node: Control: set = set_child_node

@export_group("Nodes")
@export var log_container: Control

func set_child_node(node: Control):
	if !node: return
	child_node = node

	add_log(node)

func add_log(log: Control):
	log_container.add_child(log)
