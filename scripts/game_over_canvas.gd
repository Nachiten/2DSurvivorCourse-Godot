extends CanvasLayer

func _ready():
	visible = false

func _on_game_manager_game_lost():
	visible = true
