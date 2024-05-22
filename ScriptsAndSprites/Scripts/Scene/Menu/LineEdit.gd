extends LineEdit

var if_begin: bool = false

var warning_counter: int = 0

@export var current_player_id: String = "CEssmmhhDDMMYY"
@export var LEADER_ID: String
@export var SCORE: int

@onready var help: Label = $"../Help"
@onready var best_score: Label = $"../BestScore"
@onready var controls: Label = $"../Controls"
@onready var warning: Label = $"../Warning"
@onready var audio_state: Label = $"../AudioInfo"

@onready var player_id_label: Label = $"../player_id"

@onready var timer: Timer = $"../action_timer"



var music_bus = AudioServer.get_bus_index("Master")

func _ready():
	hide_all()
	set_player_id()
	load_score()
	player_id_label.text = "ID: " + current_player_id
	select()

func set_player_id():
	var time = Time.get_datetime_dict_from_system(false)
	current_player_id = "CE%02d%02d%02d%02d%02d%02d" % [time.second, time.minute, time.hour, time.day, time.month, time.year]
	SingletoToPassData.PLAYER_ID = current_player_id

func hide_all():
	help.hide()
	controls.hide()
	best_score.hide()
	warning.hide()
	audio_state.hide()

func mute_all_sounds():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))

func _on_text_submitted(new_text):
	hide_all()
	text = ""
	if new_text == "help":
		help.show()
		set_default_warning()
	
	elif new_text == "begin":
		if_begin = true
		set_default_warning()
		SceneTransition.change_scene_to_file("res://ScriptsAndSprites/Scripts/Scene/Space/space.tscn")
	
	elif new_text == "cntrls":
		controls.show()
		set_default_warning()
	
	elif new_text == ":q":
		#print("quitting")
		get_tree().quit()
		set_default_warning()
	
	elif new_text == "sl":
		best_score.show()
		set_default_warning()
	
	elif new_text == "mute":
		mute_all_sounds()
		audio_state.show()
		if AudioServer.is_bus_mute(music_bus):
			audio_state.text = "Audio is muted"
		elif !AudioServer.is_bus_mute(music_bus):
			audio_state.text = "Audio is unmuted"
		set_default_warning()
	
	elif new_text == "clear":
		text = ""
		set_default_warning()
	
	else:
		warning_counter += 1
		warning_counter = clamp(warning_counter, 0, 4)
		if warning_counter > 3:
			warning.text = "Command not found!\nType help to get help"
		warning.show()

func set_default_warning():
	warning_counter = 0
	warning.text = "Command not found!"

func load_score():
	var pID: String = "CE00000000000000"
	var p5core: int = 0
	
	# Old loading algor.
	if FileAccess.file_exists(SingletoToPassData.SAVE_PATH):
		#print("file found")
		var file = FileAccess.open(SingletoToPassData.SAVE_PATH, FileAccess.READ)
		p5core = file.get_var()
		pID = file.get_var()
	
	best_score.text = pID + " - " + str(p5core)

	#print(SingletoToPassData.PLAYER_ID, " - ", SingletoToPassData.PLAYER_SCORE)
