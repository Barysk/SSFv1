extends Node2D

var SAVE_PATH: String = "user://save/Sc073.dat"

@onready var PLAYER_ID: String = ""
@onready var PLAYER_SCORE: int = 0

func play_save_sound():
	$DataSaved.play()
