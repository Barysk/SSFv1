extends "res://ScriptsAndSprites/Scripts/BaseClass/entity_star_ship.gd"

signal player_destroyed_enemy_ship

var player_rotation_direction = Vector2.ZERO
var player_is_attacking = false

@export var player_score: int = 0

@onready var player_star_ship_projectile: PackedScene = load("res://ScriptsAndSprites/Scripts/Player/Starship/player_star_ship_projectile.tscn")
@onready var player_feuring_rate_timer: Timer = $Timer
@onready var iniTimer: Timer = $InitialTimer
@onready var invincibilityTimer: Timer = $InvincibilityTimer

@onready var player_hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var player_condition_MAX: Texture2D = load("res://ScriptsAndSprites/Sprites/Player/Starship/player_sprite_max_hp.png")
@onready var player_condition_MID: Texture2D = load("res://ScriptsAndSprites/Sprites/Player/Starship/player_sprite_mid_hp.png")
@onready var player_condition_MIN: Texture2D = load("res://ScriptsAndSprites/Sprites/Player/Starship/player_sprite_min_hp.png")

func _ready():
	player_hurtbox_collision.set_deferred("disabled", true)
	player_sprite.texture = player_condition_MAX
	player_sprite.modulate = "ffffff16"
	iniTimer.start()
	#$IDDebug.text = SingletoToPassData.PLAYER_ID

func _physics_process(delta):
	get_player_attack_input()
	get_player_movement_input(delta)
	move()

func get_player_movement_input(delta):
	# you can make it more readable
	var input_movement_direction = Vector2.ZERO
	input_movement_direction.x = Input.get_action_strength("kb_move_right") - Input.get_action_strength("kb_move_left")
	input_movement_direction.y = Input.get_action_strength("kb_move_down") - Input.get_action_strength("kb_move_up")
	input_movement_direction = input_movement_direction.normalized()
	
	if input_movement_direction:
		velocity = velocity.move_toward(input_movement_direction * speed, acceleration * delta)
		if not player_is_attacking:
			rotation = player_rotation_direction.angle_to_point(input_movement_direction)	# Make it smooth in future
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

func get_player_attack_input():
	var input_attack_direction = Vector2.ZERO
	input_attack_direction.x = Input.get_action_strength("kb_atck_right") - Input.get_action_strength("kb_atck_left")
	input_attack_direction.y = Input.get_action_strength("kb_atck_down") - Input.get_action_strength("kb_atck_up")
	input_attack_direction = input_attack_direction.normalized()
	
	if input_attack_direction:
		player_is_attacking = true
		rotation = player_rotation_direction.angle_to_point(input_attack_direction)
		if player_feuring_rate_timer.is_stopped():
			$ShootSound.play()
			initiate_attack()
	else:
		player_is_attacking = false

func initiate_attack():
	if player_star_ship_projectile:
		var projectile = player_star_ship_projectile.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = self.global_position
		projectile.rotation = self.rotation
		player_feuring_rate_timer.start()

func _on_condition_deteriorated():
	if condition >= 3:
		player_sprite.texture = player_condition_MAX
		$HitSound.play()
		set_invincibility_frame()
	elif condition == 2:
		player_sprite.texture = player_condition_MID
		$HitSound.play()
		set_invincibility_frame()
	elif condition == 1:
		player_sprite.texture = player_condition_MIN
		$HitSound.play()
		set_invincibility_frame()
	if condition <= 0:
		emit_signal("player_star_ship_destroyed")
		destroy()

func set_invincibility_frame():
	invincibilityTimer.start()
	player_sprite.modulate = "ffffff64"
	player_hurtbox_collision.set_deferred("disabled", true)

func increment_player_score(amount):
	player_score += amount
	emit_signal("player_destroyed_enemy_ship")
	#$ScoreDebug.text = str(player_score)

func _on_initial_timer_timeout():
	player_sprite.modulate = "ffffffff"
	player_hurtbox_collision.set_deferred("disabled", false)

func _on_invincibility_timer_timeout():
	#print("starship@player > no longer invincible")
	player_hurtbox_collision.set_deferred("disabled", false)
	player_sprite.modulate = "ffffffff"

