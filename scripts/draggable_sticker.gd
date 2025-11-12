class_name DraggableSticker
extends TextureRect

@export var dragged_sticker_prefab: PackedScene
var stciker_resource: StickerData


func setTexture(new_texture: Texture2D) -> void:
	texture = new_texture

func setData(sticker_data: StickerData) -> void:
	stciker_resource = sticker_data

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = 1
	var dragged_sticker = dragged_sticker_prefab.instantiate() as DraggedSticker
	dragged_sticker.setData(stciker_resource)
	dragged_sticker.texture = texture
	dragged_sticker.scale = size / texture.get_size()
	get_tree().root.add_child(dragged_sticker)
	return data
