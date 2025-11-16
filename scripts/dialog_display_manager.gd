class_name DialogDisplayManager
extends Control

@export var fade_out_delay: float = 10.0
@export var allowed_area: ColorRect
@export var label_prefab: PackedScene
@export var max_labels: int = 3
@export var fade_out_duration: float = 1.0
@export var kaisa_text_color: Color

var character_fonts: Dictionary = {}
var character_colors: Dictionary = {}
var active_labels: Array[RichTextLabel] = []
var fade_tweens: Dictionary[RichTextLabel, Tween] = {}  # label -> tween
var typewriter_tweens: Dictionary[RichTextLabel, Tween] = {}  # label -> tween
var max_typewriter_duration: float = 8.0
var typewriter_time_per_character: float = 0.015

func _ready() -> void:
	setup_character_styles()

func setup_character_styles() -> void:
	character_fonts["kaisa"] = load("res://fonts/kaisa.ttf")
	character_fonts["ai"] = load("res://fonts/ai.ttf")
	character_fonts["thirdVoice"] = load("res://fonts/memory_voice.ttf")

	# character_colors["ai"] = kaisa_text_color

func display_dialog(character: String, text: String) -> void:
	if not allowed_area:
		push_error("allowed_area is not assigned!")
		return
	
	# Remove oldest label if at max capacity
	if active_labels.size() >= max_labels:
		remove_label_gracefully(active_labels[0])
	
	# Create new label
	var new_label = label_prefab.instantiate() as RichTextLabel
	new_label.text = "[color=#%s][outline_size=5]%s[/outline_size][/color]" % [character_colors.get(character, Color.WHITE).to_html(), text]
	new_label.visible_ratio = 0
	new_label.add_theme_font_override("normal_font", character_fonts.get(character))
	new_label.add_theme_color_override("font_color", character_colors.get(character, Color.WHITE))
	new_label.custom_minimum_size = Vector2(400, 200)
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	new_label.modulate.a = 1.0
	new_label.visible = false
	
	add_child(new_label)
	active_labels.append(new_label)
	
	await get_tree().process_frame
	
	# Find non-colliding position
	var position = find_non_colliding_position(new_label)
	new_label.global_position = position
	new_label.visible = true
	
	# Typewriter effect
	var text_length = new_label.text.length()
	var typewriter_duration = minf(float(text_length) * typewriter_time_per_character, max_typewriter_duration)
	var typewriter_tween = create_tween()
	typewriter_tween.set_trans(Tween.TRANS_LINEAR)
	typewriter_tween.tween_property(new_label, "visible_ratio", 1.0, typewriter_duration)
	typewriter_tweens[new_label] = typewriter_tween
	
	# Fade out
	var fade_tween := create_tween()
	fade_tween.tween_interval(fade_out_delay)
	set_fade_tween(new_label, fade_tween)
	fade_tween.tween_callback(func(): remove_label(new_label))
	fade_tweens[new_label] = fade_tween

func find_non_colliding_position(label: RichTextLabel) -> Vector2:
	var label_size = label.size
	var rect = allowed_area.get_global_rect()
	var padding = 10.0
	
	var max_attempts = 50
	var attempt = 0
	
	while attempt < max_attempts:
		var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x - label_size.x)
		var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y - label_size.y)
		
		var candidate_pos = Vector2(random_x, random_y)
		var candidate_rect = Rect2(candidate_pos, label_size)
		
		# Check collision with existing labels
		var collides = false
		for existing_label in active_labels:
			if existing_label == label:
				continue
			
			var existing_rect = Rect2(existing_label.global_position, existing_label.size)
			existing_rect = existing_rect.grow(padding)
			
			if candidate_rect.intersects(existing_rect):
				collides = true
				break
		
		if not collides:
			return candidate_pos
		
		attempt += 1
	
	# Fallback: stack vertically if can't find space
	var fallback_y = rect.position.y + (active_labels.size() - 1) * (label_size.y + padding)
	return Vector2(rect.position.x + padding, fallback_y)

func remove_label(label: RichTextLabel) -> void:
	active_labels.erase(label)
	
	if fade_tweens.has(label):
		fade_tweens[label].kill()
		fade_tweens.erase(label)
	
	if typewriter_tweens.has(label):
		typewriter_tweens[label].kill()
		typewriter_tweens.erase(label)
	

	label.queue_free()


func remove_label_gracefully(label: RichTextLabel) -> void:

	if fade_tweens.has(label):
		var fade_tween = fade_tweens[label]
		active_labels.erase(label)
		fade_tween.kill()
		var new_fade_tween = create_tween()
		set_fade_tween(label, new_fade_tween)
		new_fade_tween.tween_callback(func(): remove_label(label))

func set_fade_tween(label: RichTextLabel, tween: Tween) -> void:
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "modulate:a", 0.0, fade_out_duration)
