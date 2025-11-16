extends Control

func _ready() -> void:
	get_window().grab_focus()

func _on_start_pressed() -> void:
	Globals.state = Globals.GameState.FIRST_DIALOGUE
	AudioManager.transition_background_music()
	get_tree().change_scene_to_file("res://worlds/intro_scene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/credit_screen.tscn")
