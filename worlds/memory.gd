extends Control

@onready var background = $MemoryBackground

func _ready():
	if Globals.memory_image != null:
		background.texture = Globals.memory_image.texture
