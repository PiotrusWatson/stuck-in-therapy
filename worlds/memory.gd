extends Control

@onready var background = $MemoryBackground
@onready var exit_button = $MemoryBackground/ExitButton

func _ready():
	exit_button.pressed.connect(_on_exit_button_pressed)
	if Globals.memory_image != null:
		background.texture = Globals.memory_image.texture

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/end_screen.tscn")
