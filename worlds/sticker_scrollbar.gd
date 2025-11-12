class_name StickerScrollbar
extends VBoxContainer

@export var stciker_resource: Array[StickerData]
@export var sticker_prefab: PackedScene


func _ready() -> void:
	for sticker: StickerData in stciker_resource:
		var sticker_instance = sticker_prefab.instantiate() as DraggableSticker
		sticker_instance.setTexture((sticker as StickerData).sticker_texture)
		sticker_instance.setData(sticker)
		add_child(sticker_instance)
