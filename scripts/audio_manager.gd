extends Node

@export var sticker_sounds: Array[AudioStream]
@export var audio_player: Array[AudioStreamPlayer]
@export var background_music_player: AudioStreamPlayer
@export var background_music_player_second: AudioStreamPlayer
@export var background_music: AudioStream
@export var background_music_second: AudioStream

@export var volume: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in audio_player:
		player.volume_linear = volume

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
		play_sound_in_new_player(sticker_sounds[random_index])


func play_sound(sound: AudioStream) -> void:
	var is_any_player_available = false

	for player in audio_player:
		if not player.playing:
			player.stream = sound
			player.play()
			is_any_player_available = true
			return
	if not is_any_player_available:
		play_sound_in_new_player(sound)
	

func spawn_new_audio_player() -> AudioStreamPlayer:
	var new_audio_player = AudioStreamPlayer.new()
	new_audio_player.volume_linear = volume
	add_child(new_audio_player)
	audio_player.append(new_audio_player)
	return new_audio_player

func play_sound_in_new_player(sound: AudioStream) -> void:
	var new_player = spawn_new_audio_player()
	new_player.stream = sound
	new_player.play()

func play_background_music(music: AudioStream) -> void:
	if background_music_player.playing:
		background_music_player.stop()
	background_music_player.volume_linear = volume
	background_music_player.stream = music
	background_music_player.play()

func fade_in_second_background_music(music: AudioStream, fade_time: float = 1.0) -> void:
	var fade_out = create_tween()
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.finished.connect(func(): background_music_player.stop())

	background_music_player_second.volume_linear = 0
	background_music_player_second.stream = music
	# only start from the same position if both musics are the same lenght
	background_music_player_second.play(background_music_player.get_playback_position())

	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)

	fade_out.tween_property(background_music_player, "volume_linear", 0, fade_time)
	fade_in.tween_property(background_music_player_second, "volume_linear", volume, fade_time)


# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("ui_left"):
# 		play_background_music(background_music)
# 	if event.is_action_pressed("ui_right"):
# 		fade_in_second_background_music(background_music_second, 1.0)
	
