extends CharacterBody2D

@export var move_speed := 100.0

@onready var agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	var next_pos := agent.get_next_path_position()
	var dir := next_pos - position
	if dir:
		velocity = dir.normalized() * minf(move_speed, dir.length() / delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
