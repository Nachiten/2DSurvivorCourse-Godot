extends Node

@onready var pine_tree = preload("res://scenes/pine_tree.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

class Chunk:
	var coordinates: Vector3
	var explored: bool

var chunkSize = DisplayServer.window_get_size()
var currentChunk = null

func _ready():
	add_tree(Vector2(0,0))
	#add_tree(0, screen_size.y)
	#add_tree(screen_size.x, 0)
	add_tree(chunkSize)

func _process(_delta):
	var new_chunk = position_to_chunk(player.position)

	if currentChunk != new_chunk:
		currentChunk = new_chunk
		print(currentChunk)

func add_tree(position):
	var tree = pine_tree.instantiate()
	tree.position = Vector2(position.x, position.y)
	add_child(tree)

func position_to_chunk(position):
	return Vector2(floor(position.x / chunkSize.x), floor(position.y / chunkSize.y))

func chunk_to_position(chunk):
	return Vector2(chunk.x * chunkSize.x, chunk.y * chunkSize.y)
