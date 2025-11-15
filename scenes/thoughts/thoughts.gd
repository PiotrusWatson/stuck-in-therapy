extends Control

@onready var thought_box = $ThoughtBox
@export var thought_prefab: PackedScene
@export var memories: Array[MemoryData]
@onready var title = $ThoughtBox/Title
@onready var current_thoughts = []

signal response_selected(response)
signal memory_selected(memory)

func _ready():
	visible = false
	
func fill_memories():
	clear_thoughts()
	var memory: MemoryData
	match Globals.state:
		Globals.GameState.FIRST_DIALOGUE:
			memory = memories[0]
		Globals.GameState.SECOND_DIALOGUE:
			memory = memories[1]
		Globals.GameState.THIRD_DIALOGUE:
			memory = memories[2]
		_:
			print(Globals.state)
			assert("WE'RE IN THE WRONG STATE OH NO")
	var thought: Thought = thought_prefab.instantiate()
	thought_box.add_child(thought)
	thought.set_up_memory(memory)
	current_thoughts.append(thought)
	thought.memory_selected.connect(select_memory)
	
	visible = true
	if Globals.state == Globals.GameState.THIRD_DIALOGUE:
		title.text = "What do I choose?"
		thought = thought_prefab.instantiate()
		thought_box.add_child(thought)
		thought.set_up_memory(memory)
		current_thoughts.append(thought)
		thought.memory_selected.connect(select_memory)
	else:
		title.text = "Time to go..."

func fill_responses(responses):
	clear_thoughts()
	for response: DialogueResponse in responses:
		var thought: Thought = thought_prefab.instantiate()
		thought_box.add_child(thought)
		thought.set_up_response(response)
		current_thoughts.append(thought)
		thought.response_selected.connect(select_response)
	visible = true
	title.text = "What do I choose?"

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
