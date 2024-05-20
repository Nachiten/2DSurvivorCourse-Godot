extends Node

signal game_lost

func _process(_delta):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()

func _on_player_health_depleted():
	get_tree().paused = true

	game_lost.emit()
