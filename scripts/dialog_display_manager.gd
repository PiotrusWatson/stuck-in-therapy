class_name DialogDisplayManager
extends CanvasLayer

@export var fade_out_duration: float = 10.0
@export var allowed_area: ColorRect
@export var label_prefab: PackedScene

var character_fonts: Dictionary = {}
var character_colors: Dictionary = {}
var active_label: RichTextLabel = null
var fade_tween: Tween = null
var typewriter_tween: Tween = null
var max_typewriter_duration: float = 8.0
var typewriter_time_per_character: float = 0.015

func _ready() -> void:
	setup_character_styles()

func setup_character_styles() -> void:
	# Configure fonts and colors per character
	character_fonts["kaisa"] = load("res://fonts/kaisa.ttf")
	character_fonts["ai"] = load("res://fonts/ai.ttf")
	character_fonts["thirdVoice"] = load("res://fonts/memory_voice.ttf")
	
	# character_colors["kaisa"] = Color.PURPLE
	# character_colors["ai"] = Color.CYAN
	# character_colors["thirdVoice"] = Color.ORANGE

func display_dialog(character: String, text: String) -> void:
	# Kill previous tween if active
	if fade_tween:
		fade_tween.kill()
	if typewriter_tween:
		typewriter_tween.kill()
	
	# Remove previous label
	if active_label:
		active_label.queue_free()
	
	# Debug: Check if allowed_area exists
	if not allowed_area:
		push_error("allowed_area is not assigned!")
		return
	
	# Create new label
	active_label = label_prefab.instantiate()
	active_label.text = text
	active_label.text = "[outline_size=1]%s[/outline_size]" % text
	active_label.visible_ratio = 0
	active_label.add_theme_font_override("normal_font", character_fonts.get(character))
	active_label.add_theme_color_override("font_color", character_colors.get(character, Color.WHITE))
	# active_label.label_settings.shadow_color = Color.BLACK
	active_label.custom_minimum_size = Vector2(400, 200)
	active_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	active_label.modulate.a = 1.0

	active_label.visible = false
	
	add_child(active_label)
	await get_tree().process_frame
	
	var label_size = active_label.size
	var rect = allowed_area.get_global_rect()
	
	# Generate random position
	var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	# Clamp to keep label fully inside bounds
	var clamped_x = clamp(random_x, rect.position.x, rect.position.x + rect.size.x - label_size.x)
	var clamped_y = clamp(random_y, rect.position.y, rect.position.y + rect.size.y - label_size.y)
	
	active_label.position = Vector2(clamped_x, clamped_y)
	active_label.visible = true

	#TODO maybe do shorter text faster kinda like typewriter effect as it feels a bit too slow for short text
	typewriter_tween = create_tween()
	var text_length = active_label.text.length()
	var typewriter_duration = minf(float(text_length) * typewriter_time_per_character, max_typewriter_duration)
	typewriter_tween.set_trans(Tween.TRANS_LINEAR)
	typewriter_tween.tween_property(active_label, "visible_ratio", 1.0, typewriter_duration)
	
	fade_tween = create_tween()
	fade_tween.set_trans(Tween.TRANS_SINE)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	fade_tween.tween_interval(fade_out_duration)
	fade_tween.tween_property(active_label, "modulate:a", 0.0, 1.0)
	fade_tween.tween_callback(func(): active_label.queue_free())
	
