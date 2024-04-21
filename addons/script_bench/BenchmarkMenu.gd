@tool
@icon("./icon.svg")
extends Window

@export var script_path: LineEdit
var _script: Script
@export var method_selector: OptionButton
var _methods: Array[Dictionary]
@export var param_container: Control
@export var param_type_selector: OptionButton
@export var param_static_container: Control
@export var param_static: LineEdit
@export var param_generator_container: Control
@export var param_generator_selector: OptionButton
@export var run_count: SpinBox
@export var warmup_count: SpinBox
@export var run_button: Button

func _load_script():
  _script = null
  if ClassDB.class_exists(script_path.text):
    _script = ClassDB.instantiate(script_path.text)
    if not is_instance_valid(_script):
      push_error("[ScriptBench] Failed to instantiate script from name: ", script_path.text)
      return
  elif FileAccess.file_exists(script_path.text):
    var loaded_file = load(script_path.text)
    if not is_instance_valid(loaded_file):
      push_error("[ScriptBench] Failed to load script from path: ", script_path.text)
      return
    if not loaded_file is Script:
      push_error("[ScriptBench] File loaded from path was not a script: ", script_path.text)
      return
    _script = loaded_file
    if not is_instance_valid(_script):
      push_error("[ScriptBench] Failed to instantiate script from file: ", script_path.text)
      return
  if is_instance_valid(_script):
    print("[ScriptBench] Loaded script: ", script_path.text)

func _refresh_method_selectors():
  method_selector.clear()
  param_generator_selector.clear()
  method_selector.selected = -1
  param_generator_selector.selected = -1
  if not is_instance_valid(_script):
    return
  _methods = _script.get_script_method_list()
  for method in _methods:
    var method_arg_count: int = method.get("args", []).size()
    if method_arg_count > 1:
      continue
    var method_name = method.get("name")
    if method_name == null:
      continue
    if method.get("return", {}).get("type", TYPE_NIL) != TYPE_NIL and method_arg_count == 0:
      param_generator_selector.add_item(method_name)
    method_selector.add_item(method_name)

func _validate_selections():
  run_button.disabled = not is_instance_valid(_script) or method_selector.selected == -1
  param_container.visible = method_selector.selected > -1 and _methods[method_selector.selected].get("args", []).size() > 0
  if param_container.visible:
    _update_param_containers_visibility(param_type_selector.selected)

func _benchmark_no_param(method: Callable) -> Dictionary:
  var runs: int = run_count.value
  var average_runtime_coefficient := 1.0 / runs
  var average_runtime_usec := 0.0
  var fastest_runtime_usec := 9223372036854775807
  var slowest_runtime_usec := 0
  var total_exclusive_runtime_usec := 0
  var it_start: int
  var it_end: int
  var it_length: int
  print("[ScriptBench] Running ", method_selector.text, "() ", runs, " times...")
  for i in range(warmup_count.value):
    method.call()
  var start := Time.get_ticks_usec()
  for i in range(runs):
    it_start = Time.get_ticks_usec()
    method.call()
    it_end = Time.get_ticks_usec()
    it_length = it_end - it_start
    total_exclusive_runtime_usec += it_length
    average_runtime_usec += average_runtime_coefficient * it_length
    fastest_runtime_usec = min(fastest_runtime_usec, it_length)
    slowest_runtime_usec = max(slowest_runtime_usec, it_length)
  var end := Time.get_ticks_usec()
  return {
    "average_runtime_usec": average_runtime_usec,
    "fastest_runtime_usec": fastest_runtime_usec,
    "slowest_runtime_usec": slowest_runtime_usec,
    "total_runtime_usec": end - start,
    "total_exclusive_runtime_usec": total_exclusive_runtime_usec
  }

func _benchmark_static_param(method: Callable) -> Dictionary:
  var runs: int = run_count.value
  var average_runtime_coefficient := 1.0 / runs
  var average_runtime_usec := 0.0
  var fastest_runtime_usec := 9223372036854775807
  var slowest_runtime_usec := 0
  var total_exclusive_runtime_usec := 0
  var it_start: int
  var it_end: int
  var it_length: int
  var param_type: int = _methods[method_selector.selected].get("args", [{}]).front().get("type", TYPE_NIL)
  var param = type_convert(param_static.text, param_type)
  print("[ScriptBench] Running ", method_selector.text, "(", param,") ", runs, " times...")
  for i in range(warmup_count.value):
    method.call(param)
  var start := Time.get_ticks_usec()
  for i in range(runs):
    it_start = Time.get_ticks_usec()
    method.call(param)
    it_end = Time.get_ticks_usec()
    it_length = it_end - it_start
    total_exclusive_runtime_usec += it_length
    average_runtime_usec += average_runtime_coefficient * it_length
    fastest_runtime_usec = min(fastest_runtime_usec, it_length)
    slowest_runtime_usec = max(slowest_runtime_usec, it_length)
  var end := Time.get_ticks_usec()
  return {
    "average_runtime_usec": average_runtime_usec,
    "fastest_runtime_usec": fastest_runtime_usec,
    "slowest_runtime_usec": slowest_runtime_usec,
    "total_runtime_usec": end - start,
    "total_exclusive_runtime_usec": total_exclusive_runtime_usec
  }

func _benchmark_generated_param(method: Callable) -> Dictionary:
  var runs: int = run_count.value
  var average_runtime_coefficient := 1.0 / runs
  var average_runtime_usec := 0.0
  var fastest_runtime_usec := 9223372036854775807
  var slowest_runtime_usec := 0
  var total_exclusive_runtime_usec := 0
  var it_start: int
  var it_end: int
  var it_length: int
  print("[ScriptBench] Running ", method_selector.text, "(", param_generator_selector.text,"()) ", runs, " times...")
  var generator: Callable = method.get_object().get(param_generator_selector.text)
  var param_type: int = _methods[method_selector.selected].get("args", [{}]).front().get("type", TYPE_NIL)
  var params: Array
  var warmups: int = warmup_count.value
  params.resize(runs + warmups)
  for i in range(params.size()):
    params[i] = type_convert(generator.call(), param_type)
  for i in range(warmups):
    method.call(params[i])
  var start := Time.get_ticks_usec()
  for i in range(warmups, runs + warmups):
    it_start = Time.get_ticks_usec()
    method.call(params[i])
    it_end = Time.get_ticks_usec()
    it_length = it_end - it_start
    total_exclusive_runtime_usec += it_length
    average_runtime_usec += average_runtime_coefficient * it_length
    fastest_runtime_usec = min(fastest_runtime_usec, it_length)
    slowest_runtime_usec = max(slowest_runtime_usec, it_length)
  var end := Time.get_ticks_usec()
  return {
    "average_runtime_usec": average_runtime_usec,
    "fastest_runtime_usec": fastest_runtime_usec,
    "slowest_runtime_usec": slowest_runtime_usec,
    "total_runtime_usec": end - start,
    "total_exclusive_runtime_usec": total_exclusive_runtime_usec
  }

func _on_benchmark_pressed():
  var instance = _script.new()
  var method: Callable = instance.get(method_selector.text)
  if method == null:
    push_error("[ScriptBench] Failed to get method \"", method_selector.text, "\" from script: ", script_path.text)
    return
  var method_arg_count: int = _methods[method_selector.selected].get("args", []).size()
  var benchmark := _benchmark_no_param if method_arg_count == 0 else (_benchmark_static_param if param_type_selector.selected == 0 else _benchmark_generated_param)
  var result: Dictionary = benchmark.call(method)
  var runs: int = run_count.value
  var average_runtime_coefficient := 1.0 / runs
  print("[ScriptBench] Results:")
  print_time("[ScriptBench]          Min: ", result["fastest_runtime_usec"])
  print_time("[ScriptBench]          Max: ", result["slowest_runtime_usec"])
  print_time("[ScriptBench]     Avg (In): ", result["total_runtime_usec"] * average_runtime_coefficient)
  print_time("[ScriptBench]   Total (In): ", result["total_runtime_usec"])
  print_time("[ScriptBench]     Avg (Ex): ", result["average_runtime_usec"])
  print_time("[ScriptBench]   Total (Ex): ", result["total_exclusive_runtime_usec"])
  print_time("[ScriptBench]     Overhead: ", result["total_runtime_usec"] - result["average_runtime_usec"] * runs)

func print_time(prefix: String, usec):
  var scalar = 1
  var unit := "us"
  if usec > 5_000:
    scalar = 0.001
    unit = "ms"
  elif usec > 5_000_000:
    scalar = 0.000001
    unit = "s"
  print(prefix, ("%7.3f " % [usec * scalar]).lpad(10), unit)

func _on_script_path_text_changed():
  _load_script()
  _refresh_method_selectors()
  _validate_selections()

func _update_param_containers_visibility(index: int):
  param_static_container.visible = index == 0
  param_generator_container.visible = index == 1

func _on_param_type_item_selected(index: int):
  _update_param_containers_visibility(index)
