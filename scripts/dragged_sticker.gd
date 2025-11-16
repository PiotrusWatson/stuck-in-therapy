class_name DraggedSticker
extends Sprite2D

var is_dragging: bool = true

var stciker_resource: StickerData

var current_frame := 0
var timer := 0.0
var target_size: Vector2

func setData(data: StickerData, desired_size: Vector2):
	stciker_resource = data
	target_size = desired_size

	if data.sprite_sheet:
		texture = data.sprite_sheet
		hframes = data.hframes
		vframes = data.vframes
		frame = 0

		# --- Correct scaling here ---
		var frame_w = texture.get_width() / hframes
		var frame_h = texture.get_height() / vframes
		var frame_size = Vector2(frame_w, frame_h)
		scale = target_size / frame_size

	else:
		texture = data.sticker_texture

		# static texture scaling
		scale = target_size / texture.get_size()


func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

	if stciker_resource.sprite_sheet != null:
		timer += delta
		if timer >= 1.0 / stciker_resource.fps:
			timer = 0
			current_frame = (current_frame + 1) % (hframes * vframes)
			frame = current_frame

	if Input.is_action_just_released("LeftMouse") and is_dragging:
		is_dragging = false
		z_index = 15 # put the sticker behind scrollable area when dropped
		persistData()
		play_sticker_sound()

func play_sticker_sound() -> void:
	AudioManager.play_random_sticker_sound()

func persistData() -> void:
	if stciker_resource == null:
		push_error("No sticker data to persist!")
	#send data to game manager or something like that
	SignalBus.increment_sticker_count.emit()
