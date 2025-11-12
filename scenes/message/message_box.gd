extends MarginContainer
class_name MessageBox

@onready var label = $Message
@onready var panel_container = $PanelContainer
@export var your_colour: Color
@export var their_colour: Color

func set_up(text: String, is_yours: bool):
	label.text = text
	var style_box = panel_container.get_theme_stylebox("panel")
	if is_yours:
		style_box.bg_color = your_colour
		add_theme_constant_override("margin_left", 35)
	else:
		style_box.bg_color = their_colour
		add_theme_constant_override("margin_left", 5)
	panel_container.add_theme_stylebox_override("panel", style_box)
