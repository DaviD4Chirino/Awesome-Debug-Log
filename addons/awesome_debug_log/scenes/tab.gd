extends Control
@export var logs_cap: int = 10

@export var child_node: Control: set = set_child_node

@export_group("Nodes")
@export var log_container: Control

func set_child_node(node: Control):
	if !node: return
	child_node = node

	add_log(node)

func add_log(log: Control):
	log_container.add_child(log)

func _on_log_container_child_entered_tree(node: Node) -> void:
	if logs_cap <= 0:
		return
		
	if log_container.get_child_count() - 1 >= logs_cap:
		# print(log_container.get_child_count())
		log_container.get_child(0).queue_free()
	pass # Replace with function body.
