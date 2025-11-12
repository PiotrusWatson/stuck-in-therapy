class_name DraggedSticker
extends Sprite2D

var is_dragging: bool = true

var stciker_resource: StickerData

func setData(sticker_data: StickerData) -> void:
	stciker_resource = sticker_data

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

	if Input.is_action_just_released("LeftMouse") and is_dragging:
		is_dragging = false
		z_index = 15 # put the sticker behind scrollable area when dropped
		persistData()

func persistData() -> void:
	if stciker_resource == null:
		push_error("No sticker data to persist!")
	#send data to game manager or something like that
	print("Persisting sticker data: %s" % stciker_resource.sticker_name)
	pass

