extends Control

@onready var phone_screen = $PhoneScreen
@onready var thoughts = $Thoughts
@onready var load_delay_timer = $LoadDelayTimer
@onready var black_fader = $BlackToFade
@export var fade_time = 2.0
func _ready():
	phone_screen.response_choice_triggered.connect(thoughts.fill_responses)
	phone_screen.memory_choice_triggered.connect(thoughts.fill_memories)
	thoughts.response_selected.connect(phone_screen.select_response)
	thoughts.memory_selected.connect(start_moving_to_sticker)
	
func start_moving_to_sticker(memory: MemoryData):
	Globals.memory_image = memory
	if Globals.state == Globals.GameState.THIRD_DIALOGUE:
		load_delay_timer.wait_time = fade_time
		black_fader.fade_to_black(fade_time)
	load_delay_timer.start()
	
	
func _on_load_delay_timer_timeout() -> void:
	if Globals.state == Globals.GameState.FIRST_DIALOGUE or Globals.state == Globals.GameState.SECOND_DIALOGUE:
		Globals.state += 1
		get_tree().change_scene_to_file("res://worlds/memory.tscn")
	elif Globals.state == Globals.GameState.THIRD_DIALOGUE:
		Globals.state += 1
		get_tree().change_scene_to_file("res://worlds/end_screen.tscn")
	else:
		print(Globals.state)
		assert("WE'RE IN THE WRONG STATE")
