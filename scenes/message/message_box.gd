extends MarginContainer
class_name MessageBox

@onready var message = $HBoxContainer/MessagePanel
@onready var face = $HBoxContainer/Emote
@export var your_smallest_margin: int
@export var your_largest_margin: int
@export var their_smallest_margin: int
@export var their_largest_margin: int 

func set_up(text: String, is_yours: bool):
	if is_yours:
		add_theme_constant_override("margin_left", your_largest_margin)
		add_theme_constant_override("margin_right", your_smallest_margin)
		face.visible = false
	else:
		add_theme_constant_override("margin_right", their_largest_margin)
		add_theme_constant_override("margin_left", their_smallest_margin)
		face.visible = true
	message.set_up(text, is_yours)
		
	
