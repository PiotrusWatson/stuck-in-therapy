extends Control

@onready var background = $MemoryBackground
@onready var exit_button = $MemoryBackground/ExitButton

func _ready():
	if Globals.memory_image != null:
		background.texture = Globals.memory_image.texture
	exit_button.toggle_visibility(false)

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/end_screen.tscn")


func _on_memory_manager_reached_max_stickers() -> void:
	exit_button.toggle_visibility(true)
