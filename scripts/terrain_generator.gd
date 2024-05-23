extends Node2D

@onready var pine_tree = preload("res://scenes/pine_tree.tscn")
@onready var chunk_label = preload("res://scenes/chunk_label.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var line_drawer = get_node("./LineDrawer")

var chunkSize = Vector2(DisplayServer.window_get_size())
var current_chunk = null
var explored_chunks: Array[Vector2] = []

func _process(_delta):
	var new_chunk = position_to_chunk(player.position)

	if current_chunk != new_chunk:
		current_chunk = new_chunk
		print("Changed chunk to: ", current_chunk)
		generate_chunk_and_neighbors(current_chunk)

func generate_chunk_and_neighbors(center_chunk: Vector2):
	for x in range(-1, 2):
		for y in range(-1, 2):
			generate_chunk(center_chunk + Vector2(x, y))
	print("---------------")

func generate_chunk(chunk: Vector2):
	if chunk_is_explored(chunk):
		# print("Chunk already explored: ", chunk)
		return

	print("Generating chunk: ", chunk)
	explored_chunks.append(chunk)

	var chunk_coords = chunk_to_position(chunk)
	var offset = Vector2(50, 50)

	var top_left_corner = chunk_coords + offset
	var bottom_right_corner = chunk_coords + chunkSize - offset

	for i in range(15):
		var randomPos = Vector2(randf_range(top_left_corner.x, bottom_right_corner.x),
								randf_range(top_left_corner.y, bottom_right_corner.y))
		add_tree(randomPos)

	# debug_stuff(top_left_corner, bottom_right_corner, chunk)

func debug_stuff(top_left_corner, bottom_right_corner, chunk):
	line_drawer.add_line_from_to(top_left_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(top_left_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	line_drawer.add_line_from_to(bottom_right_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(bottom_right_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	var instance = chunk_label.instantiate()
	instance.global_position = top_left_corner
	instance.text = "(%s, %s)" % [chunk.x, chunk.y]
	add_child(instance)

func add_tree(_position):
	var tree = pine_tree.instantiate()
	tree.position = Vector2(_position.x, _position.y)
	add_child(tree)

func position_to_chunk(_position):
	return Vector2(floor(_position.x / chunkSize.x), floor(_position.y / chunkSize.y))

func chunk_to_position(chunk):
	return Vector2(chunk.x * chunkSize.x, chunk.y * chunkSize.y)

func chunk_is_explored(chunk):
	return explored_chunks.find(chunk) != -1
