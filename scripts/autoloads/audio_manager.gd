extends Node

@export var sticker_sounds: Array[AudioStream]
@export var kaisa_message_send: AudioStream
@export var ai_message_send: AudioStream
@export var audio_player: Array[AudioStreamPlayer]
@export var background_music_player: AudioStreamPlayer
@export var background_music_player_second: AudioStreamPlayer

@export var background_music_map: Dictionary[Globals.GameState, AudioStream]
@export var menu_background_music: AudioStream 
@export var background_music_transition_duration: float = 2.0

@export var volume_sfx: float = 0.025
@export var volume_background: float = 0.35
@export var volume_message_sfx: float = 0.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in audio_player:
		player.volume_linear = volume_sfx

	background_music_player.volume_linear = volume_background
	background_music_player_second.volume_linear = volume_background

	play_background_music(menu_background_music)
	

func play_random_sticker_sound() -> void:
	if sticker_sounds.size() == 0:
		return
	
	var is_any_player_available = false

	for player in audio_player:
		if not player.playing:
			var random_index = randi() % sticker_sounds.size()
			player.stream = sticker_sounds[random_index]
			player.play()
			is_any_player_available = true
			return
	if not is_any_player_available:
		var random_index = randi() % sticker_sounds.size()
		play_sound_in_new_player(sticker_sounds[random_index], volume_message_sfx)

func play_kaisa_message_send_sound() -> void:
	play_sound(kaisa_message_send, volume_message_sfx)

func play_ai_message_send_sound() -> void:
	play_sound(ai_message_send, volume_message_sfx)

func play_sound(sound: AudioStream, volume :float) -> void:
	var is_any_player_available = false

	for player in audio_player:
		if not player.playing:
			player.stream = sound
			player.volume_linear = volume
			player.play()
			is_any_player_available = true
			return
	if not is_any_player_available:
		play_sound_in_new_player(sound, volume)
	

func spawn_new_audio_player() -> AudioStreamPlayer:
	var new_audio_player = AudioStreamPlayer.new()
	new_audio_player.volume_linear = volume_sfx
	add_child(new_audio_player)
	audio_player.append(new_audio_player)
	return new_audio_player

func play_sound_in_new_player(sound: AudioStream, volume :float) -> void:
	var new_player = spawn_new_audio_player()
	new_player.volume_linear = volume
	new_player.stream = sound
	new_player.play()

func play_background_music(music: AudioStream) -> void:
	if background_music_player.playing:
		background_music_player.stop()
	background_music_player.volume_linear = volume_background
	background_music_player.stream = music
	background_music_player.play()

func transition_background_music() -> void:
	var current_game_state = Globals.state
	var current_player = null
	var next_player = null

	if background_music_player.playing:
		print("here means first player")
		current_player = background_music_player
		next_player = background_music_player_second
	elif background_music_player_second.playing:
		current_player = background_music_player_second
		next_player = background_music_player
	else:
		# No music is playing, just play the new music
		play_background_music(background_music_map.get(current_game_state, menu_background_music))
		return

	if not background_music_map.has(current_game_state):
		return

	var tween = create_tween()
	tween.set_parallel(true)
	var new_music := background_music_map[current_game_state]
	next_player.stream = new_music
	next_player.volume_linear = 0.0
	next_player.play()

	tween.tween_property(current_player, "volume_linear", 0.0, background_music_transition_duration)
	tween.tween_property(next_player, "volume_linear", volume_background, background_music_transition_duration)

	tween.set_parallel(false)

	tween.tween_callback(func() -> void:
		current_player.stop()
	)

	
