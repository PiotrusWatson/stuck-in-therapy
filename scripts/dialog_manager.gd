class_name DialogManager
extends Node

class CharacterDialogs:
	var character_name: String
	var percentage: float
	var moods: Dictionary = {}  # mood_name -> dialogs
	var used_indexes: Dictionary = {}  # mood_name -> used_indexes
	
	func _init(name: String, pct: float, moods_dict: Dictionary) -> void:
		character_name = name
		percentage = pct
		moods = moods_dict
		# Initialize used_indexes for each mood
		for mood_name in moods.keys():
			used_indexes[mood_name] = []
	
	func get_random_dialog(mood: String = "default") -> String:
		if not moods.has(mood):
			mood = "default"
		
		var dialogs = moods[mood] as Array[String]
		var used = used_indexes[mood]
		
		# Reset if all dialogs have been used
		if used.size() == dialogs.size():
			used_indexes[mood].clear()
			used = used_indexes[mood]
		
		# Get random unused dialog
		var available_indexes = []
		for i in range(dialogs.size()):
			if i not in used:
				available_indexes.append(i)
		
		var random_index = available_indexes[randi() % available_indexes.size()]
		used_indexes[mood].append(random_index)
		return dialogs[random_index]

var characters: Dictionary = {}
var character_moods: Dictionary = {}  # Track current mood per character

func _ready() -> void:
	SignalBus.memory_mood_change.connect(_on_memory_mood_change)

func load_dialogs(file_path: String) -> void:
	var json = JSON.new()
	var file = FileAccess.open(file_path, FileAccess.READ)
	json.parse(file.get_as_text())
	var data = json.data
	
	for character_name in data.keys():
		var char_data = data[character_name]
		var moods_dict: Dictionary = {}
		
		for mood_name in char_data["moods"].keys():
			var mood_data = char_data["moods"][mood_name]
			var dialogs_array: Array[String] = []
			for dialog in mood_data["dialogs"]:
				dialogs_array.append(dialog as String)
			moods_dict[mood_name] = dialogs_array
		
		characters[character_name] = CharacterDialogs.new(
			character_name,
			char_data["percentage"],
			moods_dict
		)
		character_moods[character_name] = "default"

func get_random_character() -> String:
	var rand = randf()
	var cumulative = 0.0
	
	for character_name in characters.keys():
		cumulative += characters[character_name].percentage
		if rand <= cumulative:
			return character_name
	
	return characters.keys()[0]

func set_character_mood(character: String, mood: String) -> void:
	if characters.has(character):
		character_moods[character] = mood

func get_dialog() -> Dictionary:
	var character = get_random_character()
	var mood = character_moods.get(character, "default")
	var dialog = characters[character].get_random_dialog(mood)
	return {"character": character, "dialog": dialog, "mood": mood}

func _on_memory_mood_change() -> void:
	print("Memory mood change triggered!")
	for character_name in characters.keys():
			set_character_mood(character_name, "sad")
