extends Node2D

func spawn_mob():
	var new_mob = preload("res://scenes/mob.tscn").instantiate()

	%EnemySpawnPathFollow.progress_ratio = randf()
	new_mob.global_position = %EnemySpawnPathFollow.global_position
	add_child(new_mob)

func _on_timer_timeout():
	spawn_mob()

func _on_player_health_depleted():
	%GameOverCanvas.visible = true
	get_tree().paused = true