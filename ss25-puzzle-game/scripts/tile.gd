class_name Tile
extends Node

@export var label: Label
@export var sprite_hat: Sprite2D

var steps := 0

func _ready() -> void:
	sprite_hat.texture = null

func add_step() -> void:
	steps += 1
	label.text = str(steps)

func remove_step() -> void:
	steps -= 1
	label.text = str(steps) if steps > 0 else ""
	var tween := create_tween()
	tween.tween_property(label, "rotation_degrees", 360.0, 0.25)
	tween.tween_callback(func() -> void: label.rotation = 0.0)
