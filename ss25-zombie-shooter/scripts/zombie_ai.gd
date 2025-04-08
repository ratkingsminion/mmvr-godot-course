extends Node

@export var agent: NavigationAgent2D

func _physics_process(delta: float) -> void:
	var target_position: Vector2
	target_position = Game.instance.player.position
	agent.target_position = target_position
