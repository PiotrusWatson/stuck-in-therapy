extends MarginContainer
class_name Thought

var response: DialogueResponse
var memory
signal response_selected(response: DialogueResponse)
@onready var button = $Button
func set_up_response(response: DialogueResponse):
	button.text = response.text
	button.disabled = false
	self.response = response

func set_up_memory(text, memory):
	button.text = text
	button.disabled = false
	self.memory = memory


func _on_button_pressed() -> void:
	response_selected.emit(response)
