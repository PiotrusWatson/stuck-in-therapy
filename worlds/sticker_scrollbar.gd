class_name StickerScrollbar
extends VBoxContainer

@export var stciker_resource: Array[Resource]
@export var sticker_prefab: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sticker in stciker_resource:
		var sticker_instance = sticker_prefab.instantiate() as dragglable_sticker
		sticker_instance.set_texture((sticker as StickerData).sticker_texture)
		add_child(sticker_instance)
