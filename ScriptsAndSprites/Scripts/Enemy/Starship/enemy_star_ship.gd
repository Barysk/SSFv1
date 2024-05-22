extends "res://ScriptsAndSprites/Scripts/BaseClass/entity_star_ship.gd"

var enemy_rotation_direction = Vector2.ZERO
var enemy_is_attacking = false

var player_node: PackedScene = null

@onready var enemy_star_ship_projectile: PackedScene = load("res://ScriptsAndSprites/Scripts/Enemy/Starship/enemy_star_ship_projectile.tscn")
@onready var enemy_feuring_rate_timer: Timer = $Timer
@onready var player: CharacterBody2D = $"../PlayerStarShip"

@onready var projectile_speed: int = randi_range(85, 110)

func _ready():
	if get_parent().has_node("PlayerStarShip"):
		player = get_parent().get_node("PlayerStarShip")
	speed = randi_range(50, 71)

func _physics_process(delta):
	if not player:
		return
	
	#turn_to_player_direction(delta)
	move_to_player(delta)
	if enemy_feuring_rate_timer.is_stopped():
		initiate_fire()
	move()

func initiate_fire():
	if enemy_star_ship_projectile:
		var projectile = enemy_star_ship_projectile.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = self.global_position
		projectile.rotation = self.rotation
		projectile.speed = self.projectile_speed
		enemy_feuring_rate_timer.start()

func move_to_player(delta):
	velocity = (player.position - position).normalized() * speed
	turn_to_player_direction(delta)

func turn_to_player_direction(_delta):
	rotation = enemy_rotation_direction.angle_to_point(velocity)
	pass

func _on_condition_deteriorated():
	
	$Hit.play()
	set_invincibility_frame()
	
	if condition == 0:
		if get_parent().has_node("PlayerStarShip"):
			emit_signal("enemy_star_ship_destroyed")
			player.increment_player_score(1)
		else:
			player = null
			return
		destroy()

func set_invincibility_frame():
	$InvincibilityTimer.start()
	$Sprite2D.modulate = "ffffff64"
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _on_invincibility_timer_timeout():
	#print("starship@enemy > no longer invincible")
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	$Sprite2D.modulate = "ffffffff"
