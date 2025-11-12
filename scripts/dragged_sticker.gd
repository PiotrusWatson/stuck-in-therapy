class_name dragged_sticker
extends Sprite2D

var is_dragging: bool = true

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

	if Input.is_action_just_released("LeftMouse"):
		is_dragging = false
		z_index = 15 # put the sticker behind scrollable area when dropped


