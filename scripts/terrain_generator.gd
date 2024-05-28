extends Node

@onready var pine_tree = preload("res://scenes/pine_tree.tscn")
@onready var chunk_label = preload("res://scenes/chunk_label.tscn")

@onready var player = get_tree().get_first_node_in_group("player")

@onready var line_drawer = $LineDrawer
@onready var trees_parent = $"../Environment"

@onready var nav_region = $"../NavigationRegion2D"

var chunk_size: Vector2 = Vector2(DisplayServer.window_get_size())
var current_chunk: Vector2 = Vector2(-200,-200)
var explored_chunks: Array[Vector2] = []

const CHUNK_TREE_AMOUNT = 15
const CHUNK_MARGIN = Vector2(10, 10)

func _process(_delta):
	var new_chunk = position_to_chunk(player.position)

	if current_chunk != new_chunk:
		current_chunk = new_chunk
		# print("Changed chunk to: ", current_chunk)
		generate_chunk_and_neighbors(current_chunk)

func generate_chunk_and_neighbors(center_chunk: Vector2):
	for x in range(-1, 2):
		for y in range(-1, 2):
			generate_chunk(center_chunk + Vector2(x, y))
	nav_region.bake_navigation_polygon()

func generate_chunk(chunk: Vector2):
	if chunk_is_explored(chunk):
		# print("Chunk already explored: ", chunk)
		return

	# print("Generating chunk: ", chunk)
	explored_chunks.append(chunk)

	var chunk_coords = chunk_to_position(chunk)

	var top_left_corner = chunk_coords + CHUNK_MARGIN
	var bottom_right_corner = chunk_coords + chunk_size - CHUNK_MARGIN

	for i in range(CHUNK_TREE_AMOUNT):
		var random_pos = Vector2(randf_range(top_left_corner.x, bottom_right_corner.x),
								randf_range(top_left_corner.y, bottom_right_corner.y))
		add_tree(random_pos, chunk, i)

	debug_stuff(top_left_corner, bottom_right_corner, chunk)

func debug_stuff(top_left_corner, bottom_right_corner, chunk):
	line_drawer.add_line_from_to(top_left_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(top_left_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	line_drawer.add_line_from_to(bottom_right_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(bottom_right_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	var chunk_label_instance = chunk_label.instantiate()
	chunk_label_instance.global_position = top_left_corner
	chunk_label_instance.text = "(%s, %s)" % [chunk.x, chunk.y]
	add_child(chunk_label_instance)

func add_tree(_position, _chunk, index):
	var tree = pine_tree.instantiate()
	tree.position = Vector2(_position.x, _position.y)
	tree.name = "(%s, %s) - %s" % [_chunk.x, _chunk.y, index]
	nav_region.add_child(tree)

func position_to_chunk(_position):
	return Vector2(floor(_position.x / chunk_size.x), floor(_position.y / chunk_size.y))

func chunk_to_position(chunk):
	return Vector2(chunk.x * chunk_size.x, chunk.y * chunk_size.y)

func chunk_is_explored(chunk):
	return explored_chunks.find(chunk) != -1
