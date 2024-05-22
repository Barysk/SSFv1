extends Node2D

@export var speed: int = 150

@onready var projectile_live_timer: Timer = $ProjectileLiveTimer

func _ready():
	projectile_live_timer.start()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta
	if projectile_live_timer.is_stopped():
		queue_free()

func _on_hitbox_area_entered(_area):
	queue_free()
