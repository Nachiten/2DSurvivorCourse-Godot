extends Sprite2D

func _on_gun_rotated(_rotation):
	if is_first_or_fourth_quadrant(_rotation):
		scale.y = 1
	else:
		scale.y = -1

func is_first_or_fourth_quadrant(angle):
	var normalized_angle = normalize_angle(angle)

	var cutValue = 90 + scale.y * 15

	var isFirstQuadrant =  normalized_angle < cutValue
	var isFourthQudrant = normalized_angle >= (360 - cutValue)

	return isFirstQuadrant || isFourthQudrant

func normalize_angle(angle):
	# Normalize the angle to be between 0 and 360 degrees
	angle = int(angle) % 360
	if angle < 0:
		angle += 360
	return angle
