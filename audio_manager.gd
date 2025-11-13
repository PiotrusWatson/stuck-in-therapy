extends Node

@export var sticker_sounds: Array[AudioStream]
@export var audio_player: Array[AudioStreamPlayer]

@export var volume_db: float = -10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in audio_player:
		player.volume_db = volume_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		play_sound_in_new_player(sound)


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
	new_audio_player.volume_db = volume_db
	add_child(new_audio_player)
	audio_player.append(new_audio_player)
	return new_audio_player

func play_sound_in_new_player(sound: AudioStream) -> void:
	var new_player = spawn_new_audio_player()
	new_player.stream = sound
	new_player.play()
