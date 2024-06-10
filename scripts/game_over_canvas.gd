extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_game_manager_game_lost() -> void:
	visible = true
