extends Control

@onready var thought_box = $ThoughtBox
@export var thought_prefab: PackedScene
@onready var title = $Title
@onready var current_thoughts = []

signal response_selected(response)
func _ready():
	visible = false
func fill_responses(responses):
	clear_thoughts()
	visible = true
	for response: DialogueResponse in responses:
		var thought: Thought = thought_prefab.instantiate()
		thought_box.add_child(thought)
		thought.set_up_response(response)
		current_thoughts.append(thought)
		thought.response_selected.connect(select_response)

func clear_thoughts():
	for thought: Thought in current_thoughts:
		thought.queue_free()
	current_thoughts.clear()

func select_response(response: DialogueResponse):
	response_selected.emit(response)
	visible = false
