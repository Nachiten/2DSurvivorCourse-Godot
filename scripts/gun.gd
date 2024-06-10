extends Area2D

signal bullets_changed(bulletsAmount: int)
signal reloading_started
signal reloading_ended
signal rotated(degrees: float)

enum ShootState { READY, COOLDOWN, RELOADING }
var state: ShootState = ShootState.READY
var maxBullets: int = 10
var bullets: int = maxBullets

@onready var shooting_point : Node2D = %ShootingPoint
@onready var reload_timer : Timer = %ReloadTimer
@onready var cooldown_timer : Timer = %CooldownTimer

const BULLET: PackedScene = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	print("gun._ready")
	resetBullets()

func _physics_process(_delta: float) -> void:
	var mouseWorldPosition: Vector2 = get_global_mouse_position()
	look_at(mouseWorldPosition)
	rotated.emit(rotation_degrees)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("primary_click") && isReady():
		shoot()

	if Input.is_action_pressed("reload") && (isReady() || isCooldown()) && !isMaxBullets():
		reload()

func isMaxBullets() -> bool:
	return bullets == maxBullets

func shoot() -> void:
	var new_bullet: Area2D = BULLET.instantiate()
	new_bullet.global_position = shooting_point.global_position
	new_bullet.global_rotation = shooting_point.global_rotation

	decreaseBullets()

	if bullets == 0:
		reload()
	else:
		state = ShootState.COOLDOWN
		cooldown_timer.start()

	shooting_point.add_child(new_bullet)

func reload() -> void:
	state = ShootState.RELOADING
	reload_timer.start()
	reloading_started.emit()

func _on_cooldown_timer_timeout() -> void:
	if isCooldown():
		state = ShootState.READY

func _on_reload_timer_timeout() -> void:
	state = ShootState.READY
	resetBullets()
	reloading_ended.emit()

func decreaseBullets() -> void:
	bullets -= 1
	bullets_changed.emit(bullets)

func resetBullets() -> void:
	bullets = maxBullets
	bullets_changed.emit(bullets)

func isReady() -> bool:
	return state == ShootState.READY

func isCooldown() -> bool:
	return state == ShootState.COOLDOWN

func isReloading() -> bool:
	return state == ShootState.RELOADING
