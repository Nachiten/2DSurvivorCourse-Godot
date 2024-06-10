extends CharacterBody2D

var health: int = 3

signal mob_killed

@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var slime: Node2D = %Slime

@onready var nav: NavigationAgent2D = $NavigationAgent2D
const SMOKE_EXPLOSION: PackedScene = preload("res://smoke_explosion/smoke_explosion.tscn")

const SPEED: float = 200
var ACCELERATION: float = 7

func _ready() -> void:
	slime.play_walk()

func _physics_process(_delta: float) -> void:
	nav.target_position = player.global_position

	var target: Vector2 = nav.get_next_path_position()
	var origin: Vector2 = global_position
	var direction: Vector2 = (target - origin).normalized()

	var intended_velocity: Vector2 = direction * SPEED
	nav.set_velocity(intended_velocity)

func take_damage() -> void:
	health -= 1
	slime.play_hurt()

	if health == 0:
		queue_free()

		var smoke: Node2D = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

		mob_killed.emit()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
