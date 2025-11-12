class_name dragglable_sticker
extends TextureRect

var is_dragging: bool = false
var mouse_offset: Vector2

@export var dragged_sticker_prefab: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = 1
	var dragged_sticker = dragged_sticker_prefab.instantiate()
	dragged_sticker.texture = texture
	dragged_sticker.scale = size / texture.get_size()
	get_tree().root.add_child(dragged_sticker)
	return data

# func _drop_data(at_position: Vector2, data: Variant) -> void:
# 	position = at_position - mouse_offset

# func _input(event: InputEvent) -> void:
# 	if event is not InputEventMouseButton:
# 		return
	
# 	var mouse_event := event as InputEventMouseButton

# 	if mouse_event.button_index == MOUSE_BUTTON_LEFT:
# 		if event.pressed:
# 			if get_rect().has_point(get_local_mouse_position()):
# 				is_dragging = true
# 				print('Dragging started on', name)
# 		else:
# 			print('dropped')
