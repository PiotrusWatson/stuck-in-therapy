extends ColorRect

@onready var fader = $Fader

func _ready():
	fader.set_up(self)

func fade_to_black():
	pass
