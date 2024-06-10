extends Node

@export var state: WaveState
@export var debug: bool = false

signal wave_space(wave: int)
signal wave_prepare(wave: int)
signal wave_started(wave: int)

@onready var wave_space_timer: Timer = $WaveSpaceTimer
@onready var wave_prepare_timer: Timer = $WavePrepareTimer

enum WaveState { WAVE_SPACE, WAVE_PREPARE, WAVE_STARTED }
# WAVE_SPACE   = Grace time between waves (5 seconds)
# WAVE_PREPARE = Warning that wave is about to start (3 seconds)
# WAVE_STARTED = Wave started, kill em all (ends when all mobs killed)
# When wave ends, state goes back to WAVE_SPACE and the cycle restarts
# Wave ends when MobSpawner signals that all mobs were killed

var wave: int = 0

func _ready() -> void:
	if debug:
		push_warning("[DEBUG] debug = true")
		wave_space_timer.wait_time = 1
		wave_prepare_timer.wait_time = 1

	end_current_wave()

func end_current_wave() -> void:
	wave += 1
	start_wave_space()

func start_wave_space() -> void:
	state = WaveState.WAVE_SPACE
	wave_space.emit(wave)
	wave_space_timer.start()

func start_wave_prepare() -> void:
	state = WaveState.WAVE_PREPARE
	wave_prepare.emit(wave)
	wave_prepare_timer.start()

func start_wave() -> void:
	state = WaveState.WAVE_STARTED
	wave_started.emit(wave)

func _on_wave_space_timer_timeout() -> void:
	start_wave_prepare()

func _on_wave_prepare_timer_timeout() -> void:
	start_wave()

func _on_mob_spawner_round_ended() -> void:
	end_current_wave()
