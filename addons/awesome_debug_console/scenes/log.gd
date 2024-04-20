@tool
extends HBoxContainer

@export var title: String = "UNTITLED": set = set_title
var value: Variant = null: set = set_value

@onready var title_label = $Title
@onready var value_label = $Value

func set_title(new_title: String):
	title = new_title
	title_label.text = title

func set_value(new_value: Variant):
	value = new_value
	if !value:
		return
	value_label.text = str(value)

func _ready():
	self.value = InputEventKey.new()
