extends Control

@onready var phone_screen = $PhoneScreen
@onready var thoughts = $Thoughts
@onready var load_delay_timer = $LoadDelayTimer
func _ready():
	phone_screen.response_choice_triggered.connect(thoughts.fill_responses)
	phone_screen.memory_choice_triggered.connect(thoughts.fill_memories)
	thoughts.response_selected.connect(phone_screen.select_response)
	thoughts.memory_selected.connect(start_moving_to_sticker)
	
func start_moving_to_sticker(memory: MemoryData):
	Globals.memory_image = memory
	load_delay_timer.start()
	
	
func _on_load_delay_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://worlds/memory.tscn")
