class_name Fader
extends Node

var thing_to_fade: CanvasItem


func set_up(thing_to_fade: CanvasItem):
	self.thing_to_fade = thing_to_fade
	
func fade_in(duration: float) -> void:
	thing_to_fade.modulate.a = 0.0  # Start invisible

	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_property(thing_to_fade, "modulate:a", 1.0, duration)

func fade_out(duration: float):
	thing_to_fade.modulate.a = 1.0 # Start invisible

	var fade_out = create_tween()
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.tween_property(thing_to_fade, "modulate:a", 0.0, duration)
