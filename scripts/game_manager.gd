extends Node

signal game_lost

func _on_player_health_depleted():
	get_tree().paused = true

	game_lost.emit()
