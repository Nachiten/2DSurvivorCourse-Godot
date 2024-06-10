extends Label

@onready var label_hide_timer: Timer = %LabelHideTimer

func _ready() -> void:
	hide_text()

func hide_text() -> void:
	visible = false

func show_text(_text: String) -> void:
	visible = true
	text = _text
	label_hide_timer.start()

func _on_label_hide_timer_timeout() -> void:
	hide_text()

func _on_waves_manger_wave_space(wave: int) -> void:
	if wave == 1:
		show_text("PREPARE TO SURVIVE")
		return

	show_text("WAVE %s ENDED" % (wave - 1))

func _on_waves_manger_wave_prepare(wave: int) -> void:
	show_text("PREPARE FOR WAVE %s" % wave)

func _on_waves_manger_wave_started(wave: int) -> void:
	show_text("WAVE %s STARTED!" % wave)
