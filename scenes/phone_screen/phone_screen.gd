extends ColorRect

@export var dialogue_to_use: DialogueResource
@export var message_box_prefab: PackedScene
@onready var messages = $MessageBackground/MessageScroller/Messages
@onready var message_timer = $Timers/MessageTimer
@onready var message_scroller = $MessageBackground/MessageScroller
@onready var scrollbar = message_scroller.get_v_scroll_bar()
signal memory_choice_triggered
signal response_choice_triggered(responses)
signal thought_parsed(text)
var current_line: DialogueLine
func _ready():
	current_line = await DialogueManager.get_next_dialogue_line(dialogue_to_use)
	parse_and_make_message(current_line)
	scrollbar.changed.connect(handle_scrollbar_changed)
	message_timer.start()

func handle_scrollbar_changed():
	message_scroller.scroll_vertical = scrollbar.max_value
	
func select_response(response: DialogueResponse):
	current_line = await dialogue_to_use.get_next_dialogue_line(response.next_id)
	parse_and_make_message(current_line)
	message_timer.start()
	
func parse_character(character: String):
	if character.to_lower() == "ai":
		return false
	else:
		return true
		
func is_thought(text: String):
	return text.begins_with("**")

		
func parse_and_make_message(dialogue_line: DialogueLine):
	var is_yours = parse_character(dialogue_line.character)
	var text = dialogue_line.text
	if is_yours and is_thought(text):
		thought_parsed.emit(text)
		return
	if dialogue_line.responses.size() > 0:
		response_choice_triggered.emit(dialogue_line.responses)
		message_timer.stop()
	return make_message(text, is_yours)
	
func make_message(text, is_yours):
	var message: MessageBox = message_box_prefab.instantiate() 
	messages.add_child(message)
	message.set_up(text, is_yours)
	message.grab_focus()
	return message


func _on_message_timer_timeout() -> void:
	current_line = await dialogue_to_use.get_next_dialogue_line(current_line.next_id)
	if current_line == null:
		memory_choice_triggered.emit()
		message_timer.stop()
		return
	parse_and_make_message(current_line)
