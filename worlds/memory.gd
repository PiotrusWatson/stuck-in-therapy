extends Control

@onready var background = $MemoryBackground
@onready var exit_button = $MemoryBackground/ExitButton
@export var transition_background: ColorRect
@export var dragging_cursor: Texture2D
@export var non_dragging_cursor: Texture2D
@export var cursor_size: int = 32
@export var background_fade_duration: float = 1.0

func _ready():
	if Globals.memory_image != null:
		background.texture = Globals.memory_image.texture
	transition_background.visible = true
	var transition_background_tween = create_tween()
	transition_background_tween.tween_property(transition_background, "modulate:a", 0.0, background_fade_duration)
	transition_background_tween.tween_callback(func ():transition_background.visible = false)

	if dragging_cursor != null and non_dragging_cursor != null:

		var resized_dragging_cursor = set_scaled_cursor(dragging_cursor, cursor_size)
		var resized_non_dragging_cursor = set_scaled_cursor(non_dragging_cursor, cursor_size)

		Input.set_custom_mouse_cursor(resized_dragging_cursor, Input.CURSOR_CAN_DROP, Vector2(cursor_size / 2.0, cursor_size / 2.0))
		# Because scrollbar is forbidden to drop, we set the forbidden cursor when over the scrollbar
		Input.set_custom_mouse_cursor(resized_dragging_cursor, Input.CURSOR_FORBIDDEN, Vector2(cursor_size / 2.0, cursor_size / 2.0))
		Input.set_custom_mouse_cursor(resized_non_dragging_cursor, Input.CURSOR_ARROW, Vector2(cursor_size / 2.0, cursor_size / 2.0))

func _on_exit_button_pressed() -> void:
	var transition_background_tween = create_tween()
	transition_background.visible = true
	transition_background_tween.tween_property(transition_background, "modulate:a", 1, background_fade_duration)
	transition_background_tween.tween_callback(transition_to_next_scene)

func transition_to_next_scene() -> void:
	Globals.state += 1
	resetCursor()
	get_tree().change_scene_to_file("res://worlds/piotrus_scene.tscn")


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func resetCursor() -> void:
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)

	Input.set_custom_mouse_cursor(null, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_FORBIDDEN)

func set_scaled_cursor(texture: Texture2D, scale: float) -> ImageTexture:
	var img := texture.get_image()
	img.resize(cursor_size, cursor_size)
	return ImageTexture.create_from_image(img)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Update cursor based on whether dragging or not
		if Input.is_action_just_pressed("LeftMouse"):
			Input.set_custom_mouse_cursor(set_scaled_cursor(dragging_cursor, cursor_size), Input.CURSOR_ARROW,  Vector2(cursor_size / 2.0, cursor_size / 2.0))
		if Input.is_action_just_released("LeftMouse"):
			Input.set_custom_mouse_cursor(set_scaled_cursor(non_dragging_cursor, cursor_size), Input.CURSOR_ARROW, Vector2(cursor_size / 2.0, cursor_size / 2.0))
