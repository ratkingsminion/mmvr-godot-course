class_name Health
extends Node2D

@export var progress_bar: ProgressBar
@export var max_health := 10

@onready var health := max_health

signal on_hit

func _ready() -> void:
	progress_bar.value = 100.0

func _process(delta: float) -> void:
	var mp := get_viewport().get_mouse_position()
	var wmp := Game.instance.screen_to_world(mp)
	var dir := wmp.direction_to(get_parent().position)
	rotation = atan2(dir.y, dir.x)

func hurt(damage: int) -> void:
	health -= damage
	if damage > 0: on_hit.emit()
	if health <= 0:
		print("I DIE!")
		get_parent().queue_free()
	progress_bar.value = remap(health, 0, max_health, 0.0, 100.0)
