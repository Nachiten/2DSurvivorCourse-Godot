extends Sprite2D

func _on_gun_rotated(_rotation: float) -> void:
	if is_first_or_fourth_quadrant(_rotation):
		scale.y = 1
	else:
		scale.y = -1

func is_first_or_fourth_quadrant(angle: float) -> bool:
	var normalized_angle: float = normalize_angle(angle)
	var cutValue: float = 90 + scale.y * 15

	var isFirstQuadrant: bool = normalized_angle < cutValue
	var isFourthQudrant: bool = normalized_angle >= (360 - cutValue)

	return isFirstQuadrant || isFourthQudrant

# Normalize the angle to be between 0 and 360 degrees
func normalize_angle(angle: float) -> float:
	angle = int(angle) % 360
	if angle < 0:
		angle += 360
	return angle
