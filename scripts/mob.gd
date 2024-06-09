extends CharacterBody2D

var health = 3

signal mob_killed

@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var slime: Node2D = %Slime

@onready var nav: NavigationAgent2D = $NavigationAgent2D

const SPEED = 200
var ACCELERATION = 7

func _ready():
	slime.play_walk()

func _physics_process(_delta: float) -> void:
	nav.target_position = player.global_position

	var target = nav.get_next_path_position()
	var origin = global_position
	var direction = (target - origin).normalized()

	var intended_velocity = direction * SPEED
	nav.set_velocity(intended_velocity)

func take_damage():
	health -= 1
	slime.play_hurt()

	if health == 0:
		queue_free()

		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

		mob_killed.emit()

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
