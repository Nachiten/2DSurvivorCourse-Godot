extends Node

func spawn_mob():
	var new_mob = preload("res://scenes/mob.tscn").instantiate()

	%EnemySpawnPathFollow.progress_ratio = randf()
	new_mob.global_position = %EnemySpawnPathFollow.global_position
	add_child(new_mob)

func _on_enemy_spawn_timer_timeout():
	spawn_mob()
