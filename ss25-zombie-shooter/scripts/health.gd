class_name Health
extends Node

@export var progress_bar: ProgressBar
@export var max_health := 10

@onready var health := max_health

func _ready() -> void:
	progress_bar.value = 100.0

func hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		print("I DIE!")
		get_parent().queue_free()
	progress_bar.value = remap(health, 0, max_health, 0.0, 100.0)
