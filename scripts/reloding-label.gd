extends Label

@onready var gun : Area2D = get_tree().get_first_node_in_group("gun")

func _ready():
	visible = false

	gun.reloading_started.connect(_gun_reloading_started)
	gun.reloading_ended.connect(_gun_reloading_ended)

func _gun_reloading_started():
	visible = true

func _gun_reloading_ended():
	visible = false
