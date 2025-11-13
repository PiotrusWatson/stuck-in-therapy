extends Control

@onready var phone_screen = $PhoneScreen
@onready var thoughts = $Thoughts

func _ready():
	phone_screen.response_choice_triggered.connect(thoughts.fill_responses)
	thoughts.response_selected.connect(phone_screen.select_response)
