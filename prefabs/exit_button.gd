extends Button

@onready var fader = $Fader
@export var fade_speed = 0.5

func _ready() -> void:
	fader.set_up(self)

func toggle_visibility(is_visible):
	visible = is_visible
	disabled = !is_visible
	if is_visible:
		fader.fade_in(fade_speed)
	else:
		fader.fade_out(fade_speed)
	
	
