extends Node2D

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
