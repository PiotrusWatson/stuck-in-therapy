extends Control
	
func _on_back_to_menu_timeout() -> void:
	get_tree().change_scene_to_file("res://worlds/title/title_screen.tscn")
