extends Node

var current_sticker_count: int = 0

@export var sticker_max_count: int = 10
@onready var dialog_manager = DialogManager.new()
var dialog_display: DialogDisplayManager

signal increment_sticker_count()


func _ready() -> void:
	increment_sticker_count.connect(on_increment_sticker_count)
	dialog_manager.load_dialogs("res://resources/memory_dialogs.json")
	dialog_display = get_tree().root.get_node("Memory/MemoryBackground/DialogDisplayManager")

func on_increment_sticker_count() -> void:
	current_sticker_count += 1
	var dialog_data = dialog_manager.get_dialog()
	
	# Display on UI
	dialog_display.display_dialog(dialog_data["character"], dialog_data["dialog"])
	
	print("%s: %s" % [dialog_data["character"], dialog_data["dialog"]])
	print("Current sticker count: %d" % current_sticker_count)
	if current_sticker_count >= sticker_max_count:
		print("Sticker max count reached!")
