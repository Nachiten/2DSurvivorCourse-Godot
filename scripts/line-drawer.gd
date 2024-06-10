extends Node2D

var lines: Array[Line] = []

func update_draw() -> void:
	queue_redraw()

func add_line(from: Vector2, to: Vector2, color: Color, width: float) -> void:
	lines.append(Line.new(from, to, color, width))
	queue_redraw()

func add_line_from_to(from: Vector2, to: Vector2) -> void:
	add_line(from, to, Color.RED, 8)

func _draw() -> void:
	for line: Line in lines:
		draw_line(line.from, line.to, line.color, line.width)
