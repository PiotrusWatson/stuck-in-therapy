class_name DraggableSticker
extends TextureRect

@export var dragged_sticker_prefab: PackedScene
var stciker_resource: StickerData
var sticker_dad: Node

# Animation state
var timer := 0.0
var current_frame := 0

# Frame size (computed from sprite sheet)
var frame_w := 0
var frame_h := 0
var total_frames := 1

# ------------------------
# Set sticker data
# ------------------------
func setData(sticker_data: StickerData) -> void:
	stciker_resource = sticker_data

	if stciker_resource.sprite_sheet != null:
		# Animated sticker
		frame_w = stciker_resource.sprite_sheet.get_width() / stciker_resource.hframes
		frame_h = stciker_resource.sprite_sheet.get_height() / stciker_resource.vframes
		total_frames = stciker_resource.hframes * stciker_resource.vframes
		current_frame = 0
		_update_texture_frame()  # show first frame
	else:
		# Static sticker
		texture = stciker_resource.sticker_texture

# ------------------------
# Drag-and-drop parent
# ------------------------
func set_daddy(sticker_daddy: Node) -> void:
	sticker_dad = sticker_daddy

# ------------------------
# Drag-and-drop
# ------------------------
func _get_drag_data(at_position: Vector2) -> Variant:
	if sticker_dad == null:
		push_error("Sticker dad not assigned!")
		return 1

	if dragged_sticker_prefab == null:
		push_error("Dragged sticker prefab not assigned!")
		return 1

	var dragged_sticker = dragged_sticker_prefab.instantiate() as DraggedSticker
	dragged_sticker.setData(stciker_resource, size) # pass target size for scaling
	sticker_dad.add_child(dragged_sticker)
	return 1

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

# ------------------------
# Animate sprite sheet
# ------------------------
func _process(delta: float) -> void:
	if stciker_resource == null:
		return

	if stciker_resource.sprite_sheet != null:
		timer += delta
		if timer >= 1.0 / stciker_resource.fps:
			timer = 0
			current_frame = (current_frame + 1) % total_frames
			_update_texture_frame()

# ------------------------
# Update TextureRect with the current frame
# ------------------------
func _update_texture_frame():
	var hframe = current_frame % stciker_resource.hframes
	var vframe = current_frame / stciker_resource.hframes

	var tex = AtlasTexture.new()
	tex.atlas = stciker_resource.sprite_sheet
	tex.region = Rect2(hframe * frame_w, vframe * frame_h, frame_w, frame_h)
	texture = tex
