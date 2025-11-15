extends Node

enum ThoughtType{RESPONSE, MEMORY, MONOLOGUE}
enum MessageType{MESSAGE, STICKER}
enum GameState {FIRST_DIALOGUE, HOSPITAL, SECOND_DIALOGUE, GRAVEYARD, THIRD_DIALOGUE, END}
var state: GameState
var memory_image

var sticker_dictionary =  {
	"smile": load("res://")
}
