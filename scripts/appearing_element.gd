class_name AppearingElement
extends Sprite2D
@export var random_check_interval_max: float = 10.0
@export var random_check_interval_mix: float = 7.0
@export var appear_chance_per_interval: float = 0.1 # 10% chance to appear every interval
@export var stay_duration: float = 0.5 # 10% chance to appear every interval
@export var fade_in_out_duration: float = 0.1
@onready var random_check_Timer = Timer.new()
@onready var stay_timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_check_Timer.wait_time = get_random_check_interval()
	random_check_Timer.one_shot = false
	random_check_Timer.timeout.connect(onTimer_timeout)

	stay_timer.wait_time = stay_duration
	stay_timer.one_shot = true
	stay_timer.timeout.connect(disappear_element)

	add_child(random_check_Timer)
	add_child(stay_timer)
	random_check_Timer.start()
	visible = false
	modulate.a = 0


func onTimer_timeout() -> void:
	var rand_value = randf()
	print('timer ran out for', name, ' : ', rand_value)
	if rand_value <= appear_chance_per_interval:
		appear_element()
	else:
		random_check_Timer.wait_time = get_random_check_interval()

func appear_element() -> void:
	var tween := create_tween()
	visible = true
	tween.tween_property(self, "modulate:a", 1.0, fade_in_out_duration)
	stay_timer.start()


func disappear_element() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_in_out_duration)
	tween.tween_callback(func(): visible = false)
	tween.tween_callback(func(): random_check_Timer.start())
	random_check_Timer.wait_time = get_random_check_interval()

func get_random_check_interval() -> float:
	return randf_range(random_check_interval_mix, random_check_interval_max)
