extends TextureRect

@onready var fader = $Fader

func _ready() -> void:
	fader.set_up(self)
	fader.fade_in(2.5)
