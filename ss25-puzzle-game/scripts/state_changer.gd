extends Node

@export var to_state: Main.State
@export var input_hint_label: Control

var timer := 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_SPACE:
		if event.is_pressed() and not event.echo:
			Main.instance.change_to(to_state)

func _process(delta: float) -> void:
	if input_hint_label:
		timer += delta
		input_hint_label.visible = fposmod(timer, 0.5) < 0.25
