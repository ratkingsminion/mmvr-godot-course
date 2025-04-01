class_name Player
extends Node2D

@export var sprite: Sprite2D
@export var sprite_hat: Sprite2D
@export var hats: Array[Texture2D]

var sprite_start_y: float

func _ready() -> void:
	sprite_start_y = sprite.position.y
	sprite_hat.texture = null

func jump(seconds: float) -> void:
	var tween := create_tween()
	tween.parallel().tween_method(func(f: float) -> void: sprite.position.y = sprite_start_y + sin(f) * -6.0,
		0.0, PI, seconds)
