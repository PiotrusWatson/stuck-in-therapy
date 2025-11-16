class_name StickerScrollbar
extends VBoxContainer

@export var stciker_resource: Array[StickerData]
@export var sticker_prefab: PackedScene
@export var sticker_daddy: Node
@export var scrollbar_container: ScrollContainer
@export var scrollbar_thickness_margin: int = 18


func _ready() -> void:

	custom_minimum_size.x = scrollbar_container.size.x - scrollbar_thickness_margin
	size_flags_horizontal = 0

	for sticker: StickerData in stciker_resource:
		var sticker_instance = sticker_prefab.instantiate() as DraggableSticker
		sticker_instance.texture =(sticker as StickerData).sticker_texture
		sticker_instance.setData(sticker)
		sticker_instance.set_daddy(sticker_daddy)
		add_child(sticker_instance)
