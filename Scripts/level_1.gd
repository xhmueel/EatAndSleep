extends Node2D

@onready var bg_music = preload("res://Audio/psy.mp3")

func _ready() -> void:
	AudioManager.play_fx(bg_music, 1.2)
