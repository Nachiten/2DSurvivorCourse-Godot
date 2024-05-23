extends Node2D

class Line:
	func _init(_from, _to, _color, _width):
		from = _from
		to = _to
		color = _color
		width = _width

	var from: Vector2
	var to: Vector2
	var color: Color
	var width: float

var lines: Array[Line] = []

func update_draw():
	queue_redraw()

func add_line(from, to, color, width):
	lines.append(Line.new(from, to, color, width))
	queue_redraw()

func add_line_from_to(from, to):
	add_line(from, to, Color.RED, 8)

func _draw():
	for line in lines:
		draw_line(line.from, line.to, line.color, line.width)
