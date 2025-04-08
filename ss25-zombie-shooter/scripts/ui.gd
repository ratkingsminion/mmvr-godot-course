class_name UI
extends Node

@onready var timer: Timer = $"../Timer"
@onready var timer_label: Label = $"PanelContainer/CenterContainer/Timer Label"

func _process(delta: float) -> void:
	var time_left := timer.time_left
	var minutes := int(time_left / 60.0)
	var seconds := int(fposmod(time_left, 60.0))
	#var ms := int(fposmod(time_left, 1.0) * 1000.0)
	#timer_label.text = "%02d:%02d:%03d" % [ minutes, seconds, ms ]
	timer_label.text = "%02d:%02d" % [ minutes, seconds ]
