extends Node

var current_sticker_count: int = 0

@export var sticker_max_count: int = 10
@onready var dialog_manager = DialogManager.new()
@export var dialog_display: DialogDisplayManager
@export var exit_button: Button
var exit_unlocked: bool = false


func _ready() -> void:
	SignalBus.increment_sticker_count.connect(on_increment_sticker_count)
	dialog_manager.load_dialogs("res://resources/memory_dialogs.json")
	exit_button.visible = false

func on_increment_sticker_count() -> void:
	current_sticker_count += 1
	var dialog_data = dialog_manager.get_dialog()
	
	# Display on UI
	dialog_display.display_dialog(dialog_data["character"], dialog_data["dialog"])

	if exit_unlocked:
		return
	
	if current_sticker_count >= sticker_max_count:
		exit_unlocked = true
		print("Sticker max count reached!")
		make_exit_button_visible()

func make_exit_button_visible() -> void:
	exit_button.visible = true
	exit_button.modulate.a = 0.0  # Start invisible

	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_property(exit_button, "modulate:a", 1.0, 0.5)
