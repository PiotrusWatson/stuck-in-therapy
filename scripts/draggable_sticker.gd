class_name DraggableSticker
extends TextureRect

@export var dragged_sticker_prefab: PackedScene

func setTexture(new_texture: Texture2D) -> void:
	texture = new_texture


func _get_drag_data(at_position: Vector2) -> Variant:
	var data = 1
	var dragged_sticker = dragged_sticker_prefab.instantiate()
	dragged_sticker.texture = texture
	dragged_sticker.scale = size / texture.get_size()
	get_tree().root.add_child(dragged_sticker)
	return data
