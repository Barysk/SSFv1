extends Node2D

signal no_enemies_left

@onready var aterlife_timer: Timer = $AfterLifeTimer
@onready var wave_timer: Timer = $WaveTimer

@export var enemy_scene: PackedScene = load("res://ScriptsAndSprites/Scripts/Enemy/Starship/enemy_star_ship.tscn")
@export var data_save_scene: PackedScene = load("res://ScriptsAndSprites/Scripts/Collectables/UploadDataPoint/upload_data_point.tscn")

var enemy_count_max: int = 2
@onready var enemy_count: int = 1

func _ready():
	#spawn_save_point()
	wave_timer.start()

func _on_player_star_ship_player_star_ship_destroyed():
	$PlayerDeath.play()
	aterlife_timer.start()

func _on_after_life_timer_timeout():
	SceneTransition.change_scene_to_file("res://ScriptsAndSprites/Scripts/Scene/EndScreen/end_screen.tscn")

func _on_player_star_ship_player_destroyed_enemy_ship():
	$EnemyDeath.play()
	enemy_count -= 1
	if enemy_count <= 0:
		emit_signal("no_enemies_left")

func _on_no_enemies_left():
	## 1. Spawn Save point in camera
	spawn_save_point()
	## 2. enemy_count_max increment
	enemy_count_max += 1
	## 3. wait
	wave_timer.start()

func spawn_save_point():
	var data_save_point = data_save_scene.instantiate()
	var data_save_spawn_location = $Camera2D/Path2D2/SaveDataPointPath
	data_save_spawn_location.progress_ratio = randf()
	data_save_point.global_position = data_save_spawn_location.global_position
	call_deferred("add_child",data_save_point)

func _on_wave_timer_timeout():
	## 4. calculate new enemy_count
	enemy_count = randi_range(enemy_count_max - 1, enemy_count_max)
	## 5. Spawn enemy_count enemies
	spawn_enemies(enemy_count)

func spawn_enemies(count: int):
	for enemy_num in count:
		var enemy_instance = enemy_scene.instantiate()
		var enemy_spawn_location = $Camera2D/Path2D/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		enemy_instance.global_position = enemy_spawn_location.global_position
		call_deferred("add_child",enemy_instance)
