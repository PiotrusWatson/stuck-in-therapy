class_name Emote
extends MarginContainer

@export var normal_face: Texture2D
@export var happy_face: Texture2D
@onready var face = $Face

func _ready():
	visible = false

func show_normal():
	face.texture = normal_face
	visible = true

func show_happy():
	face.texture = happy_face
	visible = true
