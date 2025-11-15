extends Control

@onready var background = $MemoryBackground
@onready var exit_button = $MemoryBackground/ExitButton
@export var transition_background: ColorRect

func _ready():
	if Globals.memory_image != null:
		background.texture = Globals.memory_image.texture
	transition_background.visible = true
	var transition_background_tween = create_tween()
	transition_background_tween.tween_property(transition_background, "modulate:a", 0.0, 1.0)
	transition_background_tween.tween_callback(func ():transition_background.visible = false)

func _on_exit_button_pressed() -> void:
	Globals.state += 1 
	get_tree().change_scene_to_file("res://worlds/piotrus_scene.tscn")
