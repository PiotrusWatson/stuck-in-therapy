@tool
extends MarginContainer
class_name MessageBox

@onready var message = $Container/MessagePanel
@onready var face = $Container/Emote
@onready var sticker = $Container/Sticker

@export_group("Content")
@export var debug_is_your_message: bool:
	get:
		return _is_your_message
	set(value):
		_is_your_message = value
		if debug_view_as_sticker and _is_your_message:
			debug_view_as_sticker = false
		else:
			set_up(text, value)

var _is_your_message: bool = false

@export var debug_view_as_sticker: bool = false:
	get:
		if not sticker:
			return false
		return sticker.visible
	set(value):
		if value:
			set_up_sticker(sticker.texture)
		else:
			set_up(text, _is_your_message)

@export_multiline var text: String:
	get:
		if not message:
			return ""
		return message.text
	set(value):
		if not message:
			return
		message.text = value

@export_group("Margins")
@export var your_smallest_margin: int
@export var your_largest_margin: int
@export var their_smallest_margin: int
@export var their_largest_margin: int 

func set_up(text: String, is_yours: bool):
	if is_yours:
		add_theme_constant_override("margin_left", your_largest_margin)
		add_theme_constant_override("margin_right", your_smallest_margin)
		face.hide()

		if not Engine.is_editor_hint():
			AudioManager.play_kaisa_message_send_sound()
	else:
		add_theme_constant_override("margin_right", their_largest_margin)
		add_theme_constant_override("margin_left", their_smallest_margin)
		face.show_normal()

		if not Engine.is_editor_hint():
			AudioManager.play_ai_message_send_sound()

	_is_your_message = is_yours
	message.set_up(text, is_yours)

	message.visible = true
	sticker.visible = false
		
func set_up_sticker(image: Texture2D):
	_is_your_message = false

	add_theme_constant_override("margin_right", their_largest_margin)
	add_theme_constant_override("margin_left", their_smallest_margin)
	face.show_happy()

	message.visible = false
	sticker.visible = true
	sticker.texture = image

	if not Engine.is_editor_hint():
		AudioManager.play_ai_message_send_sound()
