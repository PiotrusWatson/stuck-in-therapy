extends ColorRect

@export var dialogue_to_use: DialogueResource
@export var message_box_prefab: PackedScene
@onready var messages = $MessageScroller/Messages

func _ready():
	pass
	
func make_message(text, is_yours):
	var message: MessageBox = message_box_prefab.instantiate() 
	messages.add_child(message)
	message.set_up(text, is_yours)
	return message
	
