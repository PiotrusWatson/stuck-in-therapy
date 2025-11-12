extends MarginContainer
class_name MessageBox

@onready var label = $Message
@onready var panel_container = $PanelContainer
@export var your_style: StyleBox
@export var their_style: StyleBox
@export var smallest_margin: int
@export var largest_margin: int

func set_up(text: String, is_yours: bool):
	label.text = text
	if is_yours:
		panel_container.add_theme_stylebox_override("panel", your_style)
		add_theme_constant_override("margin_left", largest_margin)
		add_theme_constant_override("margin_right", smallest_margin)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
		
	else:
		panel_container.add_theme_stylebox_override("panel", their_style)
		add_theme_constant_override("margin_right", largest_margin)
		add_theme_constant_override("margin_left", smallest_margin)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
		
	
