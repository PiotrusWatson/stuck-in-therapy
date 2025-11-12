extends MarginContainer

@onready var label = $Message

func set_up(text: String):
	label.text = text
