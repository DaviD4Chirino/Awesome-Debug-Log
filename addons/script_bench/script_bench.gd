@tool
extends EditorPlugin

func _show_benchmark_menu():
  var benchmark_menu := preload("./BenchmarkMenu.tscn").instantiate()
  get_editor_interface().popup_dialog_centered(benchmark_menu)
  benchmark_menu.close_requested.connect(benchmark_menu.queue_free)

func _enter_tree():
  add_tool_menu_item("Benchmark Method...", _show_benchmark_menu)

func _exit_tree():
  remove_tool_menu_item("Benchmark Method...")
