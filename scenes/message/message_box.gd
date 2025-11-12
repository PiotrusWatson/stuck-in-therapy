extends MarginContainer
class_name MessageBox

@onready var label = $HBoxContainer/PanelContainer/Message
@onready var panel_container = $HBoxContainer/PanelContainer
@onready var face = $HBoxContainer/Emote
@export var your_style: StyleBox
@export var their_style: StyleBox
@export var your_smallest_margin: int
@export var your_largest_margin: int
@export var their_smallest_margin: int
@export var their_largest_margin: int 

func set_up(text: String, is_yours: bool):
	label.text = text
	if is_yours:
		panel_container.add_theme_stylebox_override("panel", your_style)
		add_theme_constant_override("margin_left", your_largest_margin)
		add_theme_constant_override("margin_right", your_smallest_margin)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
		face.visible = false
		
	else:
		panel_container.add_theme_stylebox_override("panel", their_style)
		add_theme_constant_override("margin_right", your_largest_margin)
		add_theme_constant_override("margin_left", your_smallest_margin)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
		face.visible = true
		
	
