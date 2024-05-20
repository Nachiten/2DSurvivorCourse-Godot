extends Label

@onready var gun : Node2D = get_tree().get_first_node_in_group("gun")
var totalBullets = 0

func _ready():
	print("bullets_label._ready")
	gun.bullets_changed.connect(_gun_bullets_changed)

func _gun_bullets_changed(newBullets):
	if totalBullets == 0:
		totalBullets = newBullets
	text = "Ammo: " + str(newBullets) + "/10"
