extends Node

@export var spawns_remaining: int
@export var mobs_killed: int

@onready var enemy_path_follow: PathFollow2D = %EnemySpawnPathFollow
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

signal round_ended

const MOB: PackedScene = preload("res://scenes/mob.tscn")
var current_wave: Wave

# spawn_timer: float
# spawn_amount: int
var waves: Array[Wave] = [
	Wave.new(.5, 30),
	Wave.new(1.4, 12),
	Wave.new(1.3, 14),
	Wave.new(1.2, 16),
	Wave.new(1.1, 18),
	Wave.new(1.0, 20),
	Wave.new(0.9, 22),
	Wave.new(0.8, 24),
	Wave.new(0.7, 26),
	Wave.new(0.6, 28),
]

func start_wave(wave: int) -> void:
	current_wave = waves[wave - 1]

	spawns_remaining = current_wave.spawn_amount
	mobs_killed = 0

	enemy_spawn_timer.wait_time = current_wave.spawn_timer
	enemy_spawn_timer.start()

func spawn_mob() -> void:
	var new_mob: CharacterBody2D = MOB.instantiate()

	enemy_path_follow.progress_ratio = randf()
	new_mob.global_position = enemy_path_follow.global_position
	add_child(new_mob)

	new_mob.mob_killed.connect(_on_mob_killed)

func _on_enemy_spawn_timer_timeout() -> void:
	print("Spawning mob")
	spawn_mob()
	spawns_remaining -= 1
	print("Spawns remaining: %s" % spawns_remaining)

	if spawns_remaining == 0:
		enemy_spawn_timer.stop()

func _on_waves_manger_wave_started(wave: int) -> void:
	start_wave(wave)

func _on_mob_killed() -> void:
	mobs_killed += 1

	if mobs_killed == current_wave.spawn_amount:
		round_ended.emit()
