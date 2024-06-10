extends CharacterBody2D

signal health_depleted

const DAMAGE_RATE: float = 5.0
const MOVE_VELOCITY: float = 600

@export var health: float = 100.0
@export var damage_enabled: bool = true

func _ready() -> void:
	if !damage_enabled:
		push_warning("[DEBUG] damage_enabled = false")

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * MOVE_VELOCITY
	move_and_slide()

	if velocity.length() > 0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

	var overlapping_mobs: Array[Node2D] = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0 && damage_enabled:
			health_depleted.emit()
