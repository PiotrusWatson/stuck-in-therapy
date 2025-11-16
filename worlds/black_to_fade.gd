extends ColorRect

@onready var fader = $Fader

func _ready():
	fader.set_up(self)

func fade_to_black(speed: float):
	visible = true
	fader.fade_in(speed)

func fade_out(speed: float):
	fader.fade_out(speed)
