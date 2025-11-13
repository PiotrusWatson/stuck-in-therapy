extends MarginContainer
class_name Thought

var response: DialogueResponse
var memory: MemoryData
var thought_type: Globals.ThoughtType
signal response_selected(response: DialogueResponse)
signal memory_selected(memory: MemoryData)
@onready var button = $Button

func set_up_response(response: DialogueResponse):
	button.text = response.text
	button.disabled = false
	self.response = response
	thought_type = Globals.ThoughtType.RESPONSE

func set_up_memory(memory: MemoryData):
	button.text = memory.name
	button.disabled = false
	self.memory = memory
	thought_type = Globals.ThoughtType.MEMORY


func _on_button_pressed() -> void:
	match thought_type:
		Globals.ThoughtType.RESPONSE:
			response_selected.emit(response)
		Globals.ThoughtType.MEMORY:
			memory_selected.emit(memory)
