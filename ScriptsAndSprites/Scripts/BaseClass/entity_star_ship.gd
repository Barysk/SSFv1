extends CharacterBody2D

signal player_star_ship_destroyed
signal enemy_star_ship_destroyed
signal condition_deteriorated

@export var condition_max: int = 3
@export var condition: int = condition_max: set = _set_condition, get = _get_condition

@export var speed: int = 70
@export var acceleration: int = 500

@export var effect_hit: PackedScene = load("res://ScriptsAndSprites/Scripts/Effects/Hit/hit_effect.tscn")
@export var effect_destroyed: PackedScene = load("res://ScriptsAndSprites/Scripts/Effects/Explosion/destroy_effect.tscn")
@export var effect_destroyed_particles: PackedScene = load("res://ScriptsAndSprites/Scripts/Effects/ParticleExplosion/effect_particle_explosion.tscn")
@export var effect_hit_particles: PackedScene = load("res://ScriptsAndSprites/Scripts/Effects/ParticleHit/effect_particle_hit.tscn")

@onready var starship_sprite: Sprite2D = $Sprite2D
@onready var starship_collision: CollisionShape2D = $CollisionShape2D
@onready var starship_hurtbox: Area2D = $Hurtbox


## Setter function for starship condition, emitating signal "condition_deteriorated" and takes
## variable actual_condition that is a condition variable after taking damage 
func _set_condition(actual_condition: int):
	if actual_condition != condition:
		condition = clamp(actual_condition, 0, condition_max)
		emit_signal("condition_deteriorated")


## Getter function. Returning condition.
## For now, it's only exists, becouse I wanted to make a getter.
func _get_condition():
	return condition

## Function that provides physics moving
func move():
	move_and_slide()

## Function to destroy ship
func destroy():
	spawn_effect(effect_destroyed)
	spawn_effect(effect_destroyed_particles)
	queue_free()

## Function to subtract damage from health. Damage: int is a function variable
func receive_damage(damage: int):
	spawn_effect(effect_hit)
	spawn_effect(effect_hit_particles)
	self.condition -= damage

func spawn_effect(EFFECT: PackedScene):
	if EFFECT == null:
		return
	var effect = EFFECT.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = self.global_position

func _on_hurtbox_area_entered(area):
	receive_damage(area.damage)
