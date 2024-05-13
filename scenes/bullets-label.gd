extends Label

func _ready():
	var gun = get_node("../../Player/Gun")

	print(gun)

	gun.bulletsChanged.connect(_gun_bullets_changed)

func _gun_bullets_changed(newBullets):
	text = "Balas: " + str(newBullets) + "/10"
