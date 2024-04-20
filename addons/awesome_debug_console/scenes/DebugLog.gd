@tool
extends HBoxContainer

@export var title: String = &"UNTITLED": set = set_title
var value: Variant = null: set = set_value

@export var title_label: Label
@export var value_label: Label

func set_title(new_title: String):
	if !title_label: return
	title = new_title
	if title:
		title_label.text = title
	else:
		title_label.text = ""

func set_value(new_value: Variant):
	value = new_value
	if !value:
		return
	value_label.text = str(value)
