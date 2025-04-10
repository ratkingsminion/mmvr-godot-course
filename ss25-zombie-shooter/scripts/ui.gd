class_name UI
extends Node

static var instance: UI

@onready var timer: Timer = $"../Timer"
@onready var timer_label: Label = $"PanelContainer/CenterContainer/Timer Label"
@onready var hurt_panel_container: PanelContainer = $"Hurt PanelContainer"

func _enter_tree() -> void:
	instance = self
	
func _ready() -> void:
	hurt_panel_container.hide()

func _process(delta: float) -> void:
	var time_left := timer.time_left
	var minutes := int(time_left / 60.0)
	var seconds := int(fposmod(time_left, 60.0))
	#var ms := int(fposmod(time_left, 1.0) * 1000.0)
	#timer_label.text = "%02d:%02d:%03d" % [ minutes, seconds, ms ]
	timer_label.text = "%02d:%02d" % [ minutes, seconds ]

func hurt() -> void:
	hurt_panel_container.show()
	hurt_panel_container.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(hurt_panel_container, "modulate:a", 0.0, 0.3)
