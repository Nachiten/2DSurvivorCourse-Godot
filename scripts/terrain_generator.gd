extends Node

@onready var pine_tree: PackedScene = preload("res://scenes/pine_tree.tscn")
@onready var chunk_label: PackedScene = preload("res://scenes/chunk_label.tscn")

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

@onready var line_drawer: Node2D = $LineDrawer
@onready var environment: Node2D = $"../Environment"

var chunk_size: Vector2 = Vector2(DisplayServer.window_get_size())
var current_chunk: Vector2 = Vector2(-200,-200)
var explored_chunks: Array[Vector2] = []

const CHUNK_TREE_AMOUNT: int = 15
const CHUNK_MARGIN: Vector2 = Vector2(10, 10)

var current_nav_region: NavigationRegion2D

func _process(_delta: float) -> void:
	var new_chunk: Vector2 = position_to_chunk(player.position)

	if current_chunk != new_chunk:
		current_chunk = new_chunk
		# print("Changed chunk to: ", current_chunk)
		generate_chunk_and_neighbors(current_chunk)

func generate_chunk_and_neighbors(center_chunk: Vector2) -> void:
	#for x in range(-1, 2):
	#	for y in range(-1, 2):
	generate_chunk(center_chunk + Vector2(0, 0))

func generate_chunk(chunk: Vector2) -> void:
	if chunk_is_explored(chunk):
		# print("Chunk already explored: ", chunk)
		return

	# print("Generating chunk: ", chunk)
	explored_chunks.append(chunk)

	var chunk_coords: Vector2 = chunk_to_position(chunk)

	var top_left_corner: Vector2 = chunk_coords + CHUNK_MARGIN
	var bottom_right_corner: Vector2 = chunk_coords + chunk_size - CHUNK_MARGIN

	generate_chunk_nav_region(chunk, top_left_corner, bottom_right_corner)
	generate_chunk_trees(chunk, top_left_corner, bottom_right_corner)
	player.reparent(current_nav_region)
	current_nav_region.bake_navigation_polygon()

	debug_stuff(chunk, top_left_corner, bottom_right_corner)

func generate_chunk_nav_region(chunk: Vector2, top_left_corner: Vector2, bottom_right_corner: Vector2) -> void:
	# 1 - Generate a new navigationRegion2D
	var nav_region: NavigationRegion2D = NavigationRegion2D.new()
	nav_region.name = "NavRegion (%s, %s)" % [chunk.x, chunk.y]

	# 2 - Create a new poligon for it
	nav_region.navigation_polygon = NavigationPolygon.new()

	# 3 - Add 4 points to this polygon, which are marked by top_left_corner and bottom_right_corner
	var vertices: Array[Vector2] = []
	vertices.append(top_left_corner)
	vertices.append(Vector2(bottom_right_corner.x, top_left_corner.y))
	vertices.append(bottom_right_corner)
	vertices.append(Vector2(top_left_corner.x, bottom_right_corner.y))

	nav_region.navigation_polygon.set_vertices(vertices)

	# 5 - Add the navigation region as a child of the "environment" variable
	environment.add_child(nav_region)

	# 6 - Optionally set the position of the navigation region to match the chunk
	# nav_region.position = chunk

	current_nav_region = nav_region

func generate_chunk_trees(chunk: Vector2, top_left_corner: Vector2, bottom_right_corner: Vector2) -> void:
	for i: int in range(CHUNK_TREE_AMOUNT):
		var random_pos: Vector2 = Vector2(randf_range(top_left_corner.x, bottom_right_corner.x),
										  randf_range(top_left_corner.y, bottom_right_corner.y))
		add_tree(random_pos, chunk, i)

func debug_stuff(chunk: Vector2, top_left_corner: Vector2, bottom_right_corner: Vector2) -> void:
	line_drawer.add_line_from_to(top_left_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(top_left_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	line_drawer.add_line_from_to(bottom_right_corner, Vector2(top_left_corner.x, bottom_right_corner.y))
	line_drawer.add_line_from_to(bottom_right_corner, Vector2(bottom_right_corner.x, top_left_corner.y))

	var chunk_label_instance: Label = chunk_label.instantiate()
	chunk_label_instance.global_position = top_left_corner
	chunk_label_instance.text = "(%s, %s)" % [chunk.x, chunk.y]
	add_child(chunk_label_instance)

func add_tree(_position: Vector2, chunk: Vector2, index: int) -> void:
	var tree: StaticBody2D = pine_tree.instantiate()
	tree.position = Vector2(_position.x, _position.y)
	tree.name = "Tree (%s, %s) - %s" % [chunk.x, chunk.y, index]

	current_nav_region.add_child(tree)

func position_to_chunk(_position: Vector2) -> Vector2:
	return Vector2(floor(_position.x / chunk_size.x), floor(_position.y / chunk_size.y))

func chunk_to_position(chunk: Vector2) -> Vector2:
	return Vector2(chunk.x * chunk_size.x, chunk.y * chunk_size.y)

func chunk_is_explored(chunk: Vector2) -> bool:
	return explored_chunks.find(chunk) != -1
