extends Control

func _on_start_game_timer_timeout() -> void:
		get_tree().change_scene_to_file("res://worlds/piotrus_scene.tscn")
