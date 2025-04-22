extends Area3D

var bodies_inside: Array[RigidBody3D]

func _physics_process(delta: float) -> void:
	for body in bodies_inside:
		body.apply_force(Vector3.RIGHT * 4.0)

### signals:

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		bodies_inside.append(body)

func _on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		bodies_inside.erase(body)
