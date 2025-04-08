class_name Game
extends Node2D

static var instance: Game

@onready var cam: Camera2D = $Camera2D

func _enter_tree() -> void:
	instance = self

### helpers

func screen_to_world(point: Vector2) -> Vector2:
	return point / cam.zoom + cam.get_screen_center_position() \
				- get_viewport_rect().size * 0.5 / cam.zoom
