extends MarginContainer
class_name MessageBox

@onready var label = $Message
@onready var panel_container = $PanelContainer
@export var your_style: StyleBox
@export var their_style: StyleBox

func set_up(text: String, is_yours: bool):
	label.text = text
	if is_yours:
		panel_container.add_theme_stylebox_override("panel", your_style)
		add_theme_constant_override("margin_left", 150)
		add_theme_constant_override("margin_right", 5)
		
	else:
		panel_container.add_theme_stylebox_override("panel", their_style)
		add_theme_constant_override("margin_right", 150)
		add_theme_constant_override("margin_left", 5)
		
	
