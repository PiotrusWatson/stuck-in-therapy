extends Control



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/piotrus_scene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/credit_screen.tscn")
