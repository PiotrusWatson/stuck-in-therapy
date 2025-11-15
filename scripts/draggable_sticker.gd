class_name DraggableSticker
extends TextureRect

@export var dragged_sticker_prefab: PackedScene
var stciker_resource: StickerData
var sticker_dad: Node

func setTexture(new_texture: Texture2D) -> void:
	texture = new_texture

func setData(sticker_data: StickerData) -> void:
	stciker_resource = sticker_data

func set_daddy(sticker_daddy: Node) -> void:
	sticker_dad = sticker_daddy

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = 1
	var dragged_sticker = dragged_sticker_prefab.instantiate() as DraggedSticker
	dragged_sticker.setData(stciker_resource)
	dragged_sticker.texture = texture
	dragged_sticker.scale = size / texture.get_size()
	sticker_dad.add_child(dragged_sticker)
	return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
