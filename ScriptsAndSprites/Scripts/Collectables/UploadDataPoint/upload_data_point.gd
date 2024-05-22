extends Area2D

var is_player_in_saving_zone: bool = false
var going_to_be_destroyed: bool = false

var button_pressed_time: float = 0
var button_pressed_time_required: float = 3

@export var saving_done_effect: PackedScene = load("res://ScriptsAndSprites/Scripts/Collectables/ParticleSaveDone/effect_particle_save_done.tscn")

var player_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$ExistanceTimer.start()
	$TextureProgressBar.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if going_to_be_destroyed and !is_player_in_saving_zone:
		destroy_data_savepoint()
	
	if Input.is_action_pressed("kb_save_score") && is_player_in_saving_zone:
		button_pressed_time += delta
		
		if button_pressed_time >= button_pressed_time_required:
			save_progress()
	else:
		button_pressed_time = 0
	
	$TextureProgressBar.value = button_pressed_time

func spawn_effect(EFFECT: PackedScene):
	if EFFECT == null:
		return
	var effect = EFFECT.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = self.global_position

func save_progress():
	SingletoToPassData.PLAYER_SCORE = player_node.player_score
	SingletoToPassData.play_save_sound()
	
	destroy_data_savepoint()

func destroy_data_savepoint():
	spawn_effect(saving_done_effect)
	queue_free()

func _on_body_entered(body):
	if body.name == "PlayerStarShip":
		set_deferred("is_player_in_saving_zone", true)
		set_deferred("player_node", body)


func _on_body_exited(body):
	if body.name == "PlayerStarShip":
		set_deferred("is_player_in_saving_zone", false)
		set_deferred("player_node", null)


func _on_existance_timer_timeout():
	going_to_be_destroyed = true
