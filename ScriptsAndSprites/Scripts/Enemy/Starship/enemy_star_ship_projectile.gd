extends Node2D

@export var speed: int = 100

@onready var projectile_live_timer: Timer = $ProjectileLiveTimer

var projectile_explosion: PackedScene = load("res://ScriptsAndSprites/Scripts/Effects/ParticleExplosionEnemyProjectile/effect_particle_explosion.tscn")

func _ready():
	projectile_live_timer.start()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta
	if projectile_live_timer.is_stopped():
		destroy_projectile()

func destroy_projectile():
	spawn_effect(projectile_explosion)
	queue_free()

func _on_hitbox_area_entered(_area):
	destroy_projectile()

func spawn_effect(EFFECT: PackedScene):
	if EFFECT == null:
		return
	var effect = EFFECT.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = self.global_position
