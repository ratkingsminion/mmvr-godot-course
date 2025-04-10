extends Node

@export var agent: NavigationAgent2D

@onready var health: Health = $"../HealthComponent"
@onready var weapon: Node = $"../WeaponComponent"

func _ready() -> void:
	health.on_hit.connect(UI.instance.hurt)

func _physics_process(delta: float) -> void:
	var mp := get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		agent.target_position = Game.instance.screen_to_world(mp)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var dir: Vector2 = Game.instance.screen_to_world(mp) - get_parent().position
		weapon.shoot(dir)
