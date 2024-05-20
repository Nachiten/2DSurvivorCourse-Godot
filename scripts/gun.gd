extends Area2D

signal bullets_changed(bulletsAmount)
signal reloading_started
signal reloading_ended
signal rotated(degrees)

enum ShootState { READY, COOLDOWN, RELOADING }
var state = ShootState.READY
var maxBullets = 10
var bullets = maxBullets

@onready var shooting_point : Node2D = %ShootingPoint
@onready var reload_timer : Timer = %ReloadTimer
@onready var cooldown_timer : Timer = %CooldownTimer

func _ready():
	print("gun._ready")
	resetBullets()

func _physics_process(_delta):
	var mouseWorldPosition = get_global_mouse_position()
	look_at(mouseWorldPosition)
	rotated.emit(rotation_degrees)

func _process(_delta):
	if Input.is_action_pressed("primary_click") && isReady():
		shoot()

	if Input.is_action_pressed("reload") && (isReady() || isCooldown()) && !isMaxBullets():
		reload()

func isMaxBullets():
	return bullets == maxBullets

func shoot():
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = shooting_point.global_position
	new_bullet.global_rotation = shooting_point.global_rotation

	decreaseBullets()

	if bullets == 0:
		reload()
	else:
		state = ShootState.COOLDOWN
		cooldown_timer.start()

	shooting_point.add_child(new_bullet)

func reload():
	state = ShootState.RELOADING
	reload_timer.start()
	reloading_started.emit()

func _on_cooldown_timer_timeout():
	if isCooldown():
		state = ShootState.READY

func _on_reload_timer_timeout():
	state = ShootState.READY
	resetBullets()
	reloading_ended.emit()

func decreaseBullets():
	bullets -= 1
	bullets_changed.emit(bullets)

func resetBullets():
	bullets = maxBullets
	bullets_changed.emit(bullets)

func isReady():
	return state == ShootState.READY

func isCooldown():
	return state == ShootState.COOLDOWN

func isReloading():
	return state == ShootState.RELOADING
