extends MarginContainer
class_name MessageBox

@onready var message = $HBoxContainer/MessagePanel
@onready var face = $HBoxContainer/Emote
@onready var sticker = $HBoxContainer/Sticker

@export var your_smallest_margin: int
@export var your_largest_margin: int
@export var their_smallest_margin: int
@export var their_largest_margin: int 

func set_up(text: String, is_yours: bool):	
	if is_yours:
		add_theme_constant_override("margin_left", your_largest_margin)
		add_theme_constant_override("margin_right", your_smallest_margin)
		AudioManager.play_kaisa_message_send_sound()
	else:
		add_theme_constant_override("margin_right", their_largest_margin)
		add_theme_constant_override("margin_left", their_smallest_margin)
		face.show_normal()
		AudioManager.play_ai_message_send_sound()
	message.set_up(text, is_yours)
	message.visible = true
	sticker.visible = false
		
func set_up_sticker(image: Texture2D):
	add_theme_constant_override("margin_right", their_largest_margin)
	add_theme_constant_override("margin_left", their_smallest_margin)
	face.show_happy()
	message.visible = false
	sticker.visible = true
	sticker.texture = image
	AudioManager.play_ai_message_send_sound()
