extends Control

@onready var fader = $BlackToFade
@onready var button = $Continue
@onready var fade_in_timer = $FadeInTimer

func _ready():
	fader.fade_out(2)

func _on_start_game_timer_timeout() -> void:
	button.fade_in(2)



func _on_continue_pressed() -> void:
	fade_in_timer.start()
	fader.fade_to_black(1)




func _on_fade_in_timer_timeout() -> void:
	Globals.state = Globals.GameState.FIRST_DIALOGUE
	get_tree().change_scene_to_file("res://worlds/piotrus_scene.tscn")
