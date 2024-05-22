## OPENING ##
extends Control

@onready var next_message_timer: Timer = $nextMesTimer

@onready var message_num = 0

@onready var messages: Array = [
$mes1, $mes2, $mes3,
$mes4, $mes5, $mes6,
]

## First functions ##
# Called when the node enters the scene tree for the first time.
func _ready():
	
	for mes in messages:
		mes.hide()
	
	next_message_timer.start()

## Secondary functions ##
func save_result():
	#check if exists
	
	if !DirAccess.dir_exists_absolute("user://save"):
		DirAccess.make_dir_absolute("user://save")

	if FileAccess.file_exists(SingletoToPassData.SAVE_PATH):
		var p5core: int
		var _pID: String
		#print("file_found")
		#then open and get score
		var file = FileAccess.open(SingletoToPassData.SAVE_PATH, FileAccess.READ)
		p5core = file.get_var()
		_pID = file.get_var()
		#if score < new score then overwrite
		if p5core < SingletoToPassData.PLAYER_SCORE:
			file = FileAccess.open(SingletoToPassData.SAVE_PATH, FileAccess.WRITE_READ)
			file.store_var(SingletoToPassData.PLAYER_SCORE)
			file.store_var(SingletoToPassData.PLAYER_ID)
			$mes2.text = ("Score " + str(SingletoToPassData.PLAYER_SCORE) + " saved")
		else:
			$mes2.text = ("Score " + str(SingletoToPassData.PLAYER_SCORE) + " won't be saved")
		
	#if does not exist
	else:
		#print("file not found")
		#create and save data
		var file = FileAccess.open(SingletoToPassData.SAVE_PATH, FileAccess.WRITE_READ)
		file.store_var(SingletoToPassData.PLAYER_SCORE)
		file.store_var(SingletoToPassData.PLAYER_ID)
		$mes2.text = ("Score " + str(SingletoToPassData.PLAYER_SCORE) + " saved")

## Signals ##
func _on_next_mes_timer_timeout():
	
	if message_num == 1:
		save_result()
	
	if message_num == 6:
		SceneTransition.change_scene_to_file("res://ScriptsAndSprites/Scripts/Scene/Menu/cli.tscn")
	
	if message_num >= 0 and message_num < 6: 
		messages[message_num].show()	
		message_num += 1
		next_message_timer.start()	

