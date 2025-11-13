extends Control

@onready var phone_screen = $PhoneScreen
@onready var thoughts = $Thoughts
var sticker_scene = preload("res://worlds/memory.tscn")
func _ready():
	phone_screen.response_choice_triggered.connect(thoughts.fill_responses)
	thoughts.response_selected.connect(phone_screen.select_response)
