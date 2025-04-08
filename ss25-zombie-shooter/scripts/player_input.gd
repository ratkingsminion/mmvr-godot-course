extends Node

@export var agent: NavigationAgent2D

func _physics_process(delta: float) -> void:
	var mp := get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		agent.target_position = Game.instance.screen_to_world(mp)
