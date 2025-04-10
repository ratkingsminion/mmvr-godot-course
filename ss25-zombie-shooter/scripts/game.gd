class_name Game
extends Node2D

static var instance: Game

@onready var cam: Camera2D = $Camera2D
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $"Player CharacterBody2D"
@onready var zombie_spawn_timer: Timer = $ZombieSpawnTimer

const ZOMBIE = preload("res://scenes/zombie.tscn")

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	timer.timeout.connect(_on_time_out)
	#zombie_spawn_timer.timeout.connect(_spawn_zombie)
	for i in 5: _spawn_zombie()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

### signals

func _spawn_zombie() -> void:
	var zombie := ZOMBIE.instantiate()
	var points := get_tree().get_nodes_in_group("spawnpoint")
	var point := points.pick_random() as Node2D
	while point.position.distance_to(player.position) < 25.0:
		point = points.pick_random()
	zombie.position = point.position + Vector2(randf_range(-3, 3), randf_range(-3, 3))
	add_child(zombie)

func _on_time_out() -> void:
	get_tree().quit()

### helpers

func screen_to_world(point: Vector2) -> Vector2:
	return point / cam.zoom + cam.get_screen_center_position() \
				- get_viewport_rect().size * 0.5 / cam.zoom
