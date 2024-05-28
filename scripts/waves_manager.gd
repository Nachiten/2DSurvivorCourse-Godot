extends Node

@export var state: WaveState
@export var debug: bool = false

signal wave_space(wave)
signal wave_prepare(wave)
signal wave_started(wave)

@onready var wave_space_timer = $WaveSpaceTimer
@onready var wave_prepare_timer = $WavePrepareTimer

enum WaveState { WAVE_SPACE, WAVE_PREPARE, WAVE_STARTED }
# WAVE_SPACE   = Grace time between waves (5 seconds)
# WAVE_PREPARE = Warning that wave is about to start (3 seconds)
# WAVE_STARTED = Wave started, kill em all (ends when all mobs killed)
# When wave ends, state goes back to WAVE_SPACE and the cycle restarts
# Wave ends when MobSpawner signals that all mobs were killed

var wave = 0

func _ready():
	if debug:
		push_warning("[DEBUG] debug = true")
		wave_space_timer.wait_time = 1
		wave_prepare_timer.wait_time = 1

	end_current_wave()

func end_current_wave():
	wave += 1
	start_wave_space()

func start_wave_space():
	state = WaveState.WAVE_SPACE
	wave_space.emit(wave)
	wave_space_timer.start()

func start_wave_prepare():
	state = WaveState.WAVE_PREPARE
	wave_prepare.emit(wave)
	wave_prepare_timer.start()

func start_wave():
	state = WaveState.WAVE_STARTED
	wave_started.emit(wave)

func _on_wave_space_timer_timeout():
	start_wave_prepare()

func _on_wave_prepare_timer_timeout():
	start_wave()

func _on_mob_spawner_round_ended():
	end_current_wave()
