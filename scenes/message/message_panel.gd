extends PanelContainer

@export var your_font: FontFile
@export var their_font: FontFile
@export var your_style: StyleBox
@export var their_style: StyleBox
@export var your_font_size = 30
@onready var label = $Message
func set_up(text: String, is_yours: bool):
	label.text = text
	if is_yours:
		add_theme_stylebox_override("panel", your_style)
		label.add_theme_font_override("font", your_font)
		label.add_theme_font_size_override("font_size", your_font_size)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
	else:
		add_theme_stylebox_override("panel", their_style)
		label.add_theme_font_override("font", their_font)
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
