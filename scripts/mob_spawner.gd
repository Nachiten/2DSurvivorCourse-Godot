extends Node

@onready var enemy_path_follow = %EnemySpawnPathFollow

func spawn_mob():
	var new_mob = preload("res://scenes/mob.tscn").instantiate()

	enemy_path_follow.progress_ratio = randf()
	new_mob.global_position = enemy_path_follow.global_position
	add_child(new_mob)

func _on_enemy_spawn_timer_timeout():
	spawn_mob()
