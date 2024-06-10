extends Label

@onready var gun : Area2D = get_tree().get_first_node_in_group("gun")

func _ready() -> void:
	visible = false

	gun.reloading_started.connect(_gun_reloading_started)
	gun.reloading_ended.connect(_gun_reloading_ended)

func _gun_reloading_started() -> void:
	visible = true

func _gun_reloading_ended() -> void:
	visible = false
