extends Control


func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/title/title_screen.tscn")
