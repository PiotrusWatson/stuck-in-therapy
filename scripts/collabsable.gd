extends Control

@export var content: ColorRect
@export var button: Button
@export var collapsed_icon: Texture2D
@export var expanded_icon: Texture2D
var collapsed := false
var expanded_height: float = 0
var collapsed_height: float = 0

func _ready():
	button.pressed.connect(toggle)
	await get_tree().process_frame
	expanded_height = content.size.y

func toggle():
	collapsed = !collapsed
	# button.text = "Expand" if collapsed else "Collapse"
	var tween = create_tween()

	var target_height = collapsed_height if collapsed else expanded_height

	tween.tween_property(content, "size:y", target_height, 0.3).set_trans(Tween.TRANS_SINE)
