class_name DialogManager
extends Node

class CharacterDialogs:
	var character_name: String
	var percentage: float
	var dialogs: Array[String]
	var used_indexes: Array[int] = []
	
	func _init(name: String, pct: float, dialog_list: Array[String]) -> void:
		character_name = name
		percentage = pct
		dialogs = dialog_list
	
	func get_random_dialog() -> String:
		# Reset if all dialogs have been used
		if used_indexes.size() == dialogs.size():
			used_indexes.clear()
		
		# Get random unused dialog
		var available_indexes = []
		for i in range(dialogs.size()):
			if i not in used_indexes:
				available_indexes.append(i)
		
		var random_index = available_indexes[randi() % available_indexes.size()]
		used_indexes.append(random_index)
		return dialogs[random_index]

var characters: Dictionary = {}

func _ready() -> void:
	load_dialogs("res://resources/memory_dialogs.json")

func load_dialogs(file_path: String) -> void:
	var json = JSON.new()
	var file = FileAccess.open(file_path, FileAccess.READ)
	json.parse(file.get_as_text())
	var data = json.data
	
	for character_name in data.keys():
		var char_data = data[character_name]
		var dialogs_array: Array[String] = []
		for dialog in char_data["dialogs"]:
			dialogs_array.append(dialog as String)
		characters[character_name] = CharacterDialogs.new(
			character_name,
			char_data["percentage"],
			dialogs_array
		)

func get_random_character() -> String:
	var rand = randf()
	var cumulative = 0.0
	
	for character_name in characters.keys():
		cumulative += characters[character_name].percentage
		if rand <= cumulative:
			return character_name
	
	return characters.keys()[0]

func get_dialog() -> Dictionary:
	var character = get_random_character()
	var dialog = characters[character].get_random_dialog()
	return {"character": character, "dialog": dialog}
