extends Node

func _on_player_health_depleted():
	%GameOverCanvas.visible = true
	get_tree().paused = true
