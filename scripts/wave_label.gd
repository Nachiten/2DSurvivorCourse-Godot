extends Label

@onready var jorge_timer = %LabelHideTimer

func _ready():
	hide_text()

func hide_text():
	visible = false

func show_text(_text):
	visible = true
	text = _text
	jorge_timer.start()

func _on_label_hide_timer_timeout():
	hide_text()

func _on_waves_manger_wave_space(_wave):
	show_text("You may rest for now...")

func _on_waves_manger_wave_prepare(wave):
	show_text("Prepare for wave %s" % wave)

func _on_waves_manger_wave_started(wave):
	show_text("WAVE %s STARTED!" % wave)
