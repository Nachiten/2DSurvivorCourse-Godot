extends Label

func _process(_delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()
	text = "FPS: " + str(fps)
