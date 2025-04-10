class_name Weapon
extends Node

@export var cool_down := 0.5

@onready var line: Line2D = $"Shoot Line2D"
@onready var ray: RayCast2D = $"../Shoot RayCast2D"

const HIT_PARTICLES = preload("res://scenes/hit_particles.tscn")

var can_shoot := true

func _ready() -> void:
	line.hide()

func shoot(direction: Vector2) -> void:
	if not can_shoot: return
	can_shoot = false
	line.show()
	line.points[0] = get_parent().position
	
	ray.target_position = direction.normalized() * 300.0
	ray.force_raycast_update()
	if ray.is_colliding():
		var particles := HIT_PARTICLES.instantiate()
		particles.position = ray.get_collision_point()
		Game.instance.add_child(particles)
		if ray.get_collider():
			var health = ray.get_collider().find_child("HealthComponent")
			if health: health.hurt(1)
		line.points[1] = ray.get_collision_point()
	else:
		line.points[1] = ray.target_position + get_parent().position
	
	await get_tree().create_timer(cool_down).timeout
	can_shoot = true
	line.hide()
