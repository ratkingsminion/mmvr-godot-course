extends Node

@export var cool_down := 0.5

@onready var ray: RayCast2D = $"../Shoot RayCast2D"
const HIT_PARTICLES = preload("res://scenes/hit_particles.tscn")

var timer := 0.0

func shoot(direction: Vector2) -> void:
	if timer > Time.get_ticks_msec() * 0.001: return
	timer = Time.get_ticks_msec() * 0.001 + cool_down
	
	ray.target_position = direction.normalized() * 300.0
	if ray.is_colliding():
		print("HIT ", ray.get_collision_point())
		var particles := HIT_PARTICLES.instantiate()
		particles.position = ray.get_collision_point()
		Game.instance.add_child(particles)
		if ray.get_collider():
			var health = ray.get_collider().find_child("HealthComponent")
			if health: health.hurt(1)
