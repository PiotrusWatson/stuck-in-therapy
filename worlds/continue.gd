extends Button

@onready var fader = $Fader
@export var fade_speed = 2
func _ready():
	fader.set_up(self)
	disabled = true
	
func fade_in(speed):
	visible = true
	disabled = false
	fader.fade_in(speed)
	
