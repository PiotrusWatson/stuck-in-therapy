extends Node

enum ThoughtType{RESPONSE, MEMORY, MONOLOGUE}
enum MessageType{MESSAGE, STICKER}
enum GameState {FIRST_DIALOGUE, HOSPITAL, SECOND_DIALOGUE, GRAVEYARD, THIRD_DIALOGUE, END}
var state: GameState
var memory_image

var sticker_dictionary =  {
	"smile": preload("res://assets/stickers/smile.png"),
	"drink_water": preload("res://assets/stickers/drink_water.png"),
	"its_okay": preload("res://assets/stickers/its_ok.png"),
	"heart": preload("res://assets/stickers/heart.png"),
	"sparkle_heart": preload("res://assets/stickers/sparkle_heart.png"),
	"smug_star": preload("res://assets/stickers/smug_star.png"),
	"good_vibes_only": preload("res://assets/stickers/good_vibes_only.png"),
	"happy_sun": preload("res://assets/stickers/happy_sun.png"),
	"grow": preload("res://assets/stickers/grow.png"),
	"meditate": preload("res://assets/stickers/meditate.png")
}
