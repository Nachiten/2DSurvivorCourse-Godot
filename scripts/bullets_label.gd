extends Label

@onready var gun : Node2D = get_tree().get_first_node_in_group("gun")

func _ready():
	gun.bulletsChanged.connect(_gun_bullets_changed)

func _gun_bullets_changed(newBullets):
	text = "Balas: " + str(newBullets) + "/10"
