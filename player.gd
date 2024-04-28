extends CharacterBody2D

const move_velocity = 600

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * move_velocity
	move_and_slide()
