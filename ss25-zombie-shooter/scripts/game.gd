class_name Game
extends Node2D

static var instance: Game

@onready var cam: Camera2D = $Camera2D
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $"Player CharacterBody2D"

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	timer.timeout.connect(_on_time_out)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

### signals

func _on_time_out() -> void:
	get_tree().quit()

### helpers

func screen_to_world(point: Vector2) -> Vector2:
	return point / cam.zoom + cam.get_screen_center_position() \
				- get_viewport_rect().size * 0.5 / cam.zoom
