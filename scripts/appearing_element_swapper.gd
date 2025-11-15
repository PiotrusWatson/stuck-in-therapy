class_name AppearingElementSwapper
extends Node

@export var random_check_interval_max: float = 10.0
@export var random_check_interval_min: float = 7.0
@export var appear_chance_per_interval: float = 0.1
@export var stay_duration: float = 0.5
@export var fade_in_out_duration: float = 0.1

@export var current_element: CanvasItem
@export var next_element: CanvasItem

@onready var random_check_timer = Timer.new()
@onready var stay_timer = Timer.new()

func _ready() -> void:
	next_element.visible = false
	current_element.visible = true
	random_check_timer.wait_time = get_random_check_interval()
	random_check_timer.one_shot = false
	random_check_timer.timeout.connect(_on_check_timer_timeout)
	
	stay_timer.wait_time = stay_duration
	stay_timer.one_shot = true
	stay_timer.timeout.connect(_on_stay_timer_timeout)
	
	add_child(random_check_timer)
	add_child(stay_timer)
	random_check_timer.start()
	
	current_element.modulate.a = 1.0
	next_element.modulate.a = 0.0

func _on_check_timer_timeout() -> void:
	var rand_value = randf()
	if rand_value <= appear_chance_per_interval:
		swap_elements()
	else:
		random_check_timer.wait_time = get_random_check_interval()

func swap_elements() -> void:
	random_check_timer.stop()
	var tween = create_tween()
	tween.set_parallel(true)
	next_element.visible = true
	
	# Fade out current, fade in next
	tween.tween_property(current_element, "modulate:a", 0.0, fade_in_out_duration)
	tween.tween_property(next_element, "modulate:a", 1.0, fade_in_out_duration)
	
	tween.tween_callback(func(): stay_timer.start())

func _on_stay_timer_timeout() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Fade back
	tween.tween_property(current_element, "modulate:a", 1.0, fade_in_out_duration)
	tween.tween_property(next_element, "modulate:a", 0.0, fade_in_out_duration)
	
	tween.tween_callback(func() -> void:
		random_check_timer.wait_time = get_random_check_interval()
		random_check_timer.start()
		next_element.visible = false
	)

func get_random_check_interval() -> float:
	return randf_range(random_check_interval_min, random_check_interval_max)
