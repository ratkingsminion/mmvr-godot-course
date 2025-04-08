extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	var mp := get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		agent.target_position = Game.instance.screen_to_world(mp)
	
	var next_pos := agent.get_next_path_position()
	var dir := next_pos - position
	if dir:
		velocity = dir.normalized() * 100.0
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
