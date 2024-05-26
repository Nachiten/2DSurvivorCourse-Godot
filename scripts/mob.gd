extends CharacterBody2D

var health = 3

signal mob_killed

@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var slime: Node2D = %Slime

func _ready():
	slime.play_walk()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()

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
