extends Area2D

signal bulletsChanged(bulletsAmount)

enum ShootState { READY, COOLDOWN, RELOADING }
var state = ShootState.READY
var maxBullets = 10
var bullets = maxBullets

func _ready():
	resetBullets()

func _physics_process(_delta):
	var mouseWorldPosition = get_global_mouse_position()
	look_at(mouseWorldPosition)

func _process(delta):
	if Input.is_action_pressed("primary_click") && isReady():
		shoot()

func shoot():
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation

	decreaseBullets()

	if bullets == 0:
		state = ShootState.RELOADING
		%ReloadTimer.start()
	else:
		state = ShootState.COOLDOWN
		%CooldownTimer.start()

	%ShootingPoint.add_child(new_bullet)


func _on_cooldown_timer_timeout():
	if isCooldown():
		state = ShootState.READY

func _on_reload_timer_timeout():
	state = ShootState.READY
	resetBullets()

func decreaseBullets():
	bullets -= 1
	bulletsChanged.emit(bullets)

func resetBullets():
	bullets = maxBullets
	bulletsChanged.emit(bullets)

func isReady():
	return state == ShootState.READY

func isCooldown():
	return state == ShootState.COOLDOWN

func isReloading():
	return state == ShootState.RELOADING
