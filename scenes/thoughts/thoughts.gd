extends Control

@onready var thought_box = $ThoughtBox
@export var thought_prefab: PackedScene
@export var memories: Array[MemoryData]
@onready var title = $Title
@onready var current_thoughts = []

signal response_selected(response)
signal memory_selected(memory)

func _ready():
	visible = false
	
func fill_memories():
	clear_thoughts()
	for memory in memories:
		var thought: Thought = thought_prefab.instantiate()
		thought_box.add_child(thought)
		thought.set_up_memory(memory)
		current_thoughts.append(thought)
		thought.memory_selected.connect(select_memory)
	visible = true

func fill_responses(responses):
	clear_thoughts()
	for response: DialogueResponse in responses:
		var thought: Thought = thought_prefab.instantiate()
		thought_box.add_child(thought)
		thought.set_up_response(response)
		current_thoughts.append(thought)
		thought.response_selected.connect(select_response)
	visible = true

func clear_thoughts():
	for thought: Thought in current_thoughts:
		thought.queue_free()
	current_thoughts.clear()

func select_response(response: DialogueResponse):
	response_selected.emit(response)
	visible = false

func select_memory(memory: MemoryData):
	memory_selected.emit(memory)
	visible = false
