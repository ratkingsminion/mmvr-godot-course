extends RigidBody3D

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_dir := Vector3(input_dir.x, 0.0, input_dir.y)
	apply_force(move_dir * 5.0)
	
	if not move_dir:
		angular_velocity *= 0.95
		linear_velocity.x *= 0.95
		linear_velocity.z *= 0.95
	
	if Input.is_action_just_pressed("jump"):
		apply_impulse(Vector3.UP * 5.0)
