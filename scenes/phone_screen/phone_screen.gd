extends ColorRect

@export var dialogues_to_use: Array[DialogueResource]
var dialogue_to_use: DialogueResource
@export var message_box_prefab: PackedScene
@export var dotted_anim_box_prefab: PackedScene
@export var stickers: Array[Texture2D]
@onready var messages = $MessageBackground/MessageScroller/Messages
@onready var message_timer = $Timers/MessageTimer
@onready var time_before_typing = $Timers/TimeBeforeTyping
@onready var message_scroller = $MessageBackground/MessageScroller
@onready var scrollbar = message_scroller.get_v_scroll_bar()

signal memory_choice_triggered
signal response_choice_triggered(responses)
signal thought_parsed(text)
var current_line: DialogueLine
var current_dotted_anim

func _ready():
	match Globals.state:
		Globals.GameState.FIRST_DIALOGUE:
			dialogue_to_use = dialogues_to_use[0]
		Globals.GameState.SECOND_DIALOGUE:
			dialogue_to_use = dialogues_to_use[1]
		Globals.GameState.THIRD_DIALOGUE:
			dialogue_to_use = dialogues_to_use[2]
		_:
			print(Globals.state)
			assert("UH OH THIS SHOULDN'T HAPPEN (we're in the wrong state)")

	current_line = await DialogueManager.get_next_dialogue_line(dialogue_to_use)
	parse_and_make_message(current_line)
	scrollbar.changed.connect(handle_scrollbar_changed)
	message_timer.start()
	time_before_typing.start()

func handle_scrollbar_changed():
	message_scroller.scroll_vertical = scrollbar.max_value
	
func select_response(response: DialogueResponse):
	current_line = await dialogue_to_use.get_next_dialogue_line(response.next_id)
	parse_and_make_message(current_line)
	message_timer.start()
	time_before_typing.start()
	
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
	var sticker_info = dialogue_line.get_tag_value("sticker")	
	if is_yours and is_thought(text):
		thought_parsed.emit(text)
		return
	if dialogue_line.responses.size() > 0:
		response_choice_triggered.emit(dialogue_line.responses)
		message_timer.stop()
	return make_message(text, is_yours, sticker_info)
	
func make_message(text, is_yours, sticker_info):
	var message: MessageBox = message_box_prefab.instantiate()
	messages.add_child(message)
	if sticker_info != "":
		message.set_up_sticker(Globals.sticker_dictionary[sticker_info])
	else:
		message.set_up(text, is_yours)
	return message

func make_dotted_anim():
	current_dotted_anim = dotted_anim_box_prefab.instantiate()
	messages.add_child(current_dotted_anim)
	
func stop_dotted_anim():
	if current_dotted_anim == null:
		return
	current_dotted_anim.queue_free()
	current_dotted_anim = null

func _on_message_timer_timeout() -> void:
	stop_dotted_anim()
	current_line = await dialogue_to_use.get_next_dialogue_line(current_line.next_id)
	if current_line == null:
		memory_choice_triggered.emit()
		message_timer.stop()
		return
	parse_and_make_message(current_line)
	if current_line.responses.size() <= 0:
		time_before_typing.start()
	


func _on_time_before_typing_timeout() -> void:
	make_dotted_anim()
