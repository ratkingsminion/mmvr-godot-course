extends Node

enum State { IDLE, FOLLOW }

@export var agent: NavigationAgent2D
@export var view_radius := 45.0

@onready var creature: CharacterBody2D = $".."

var state: State = State.IDLE
var follow_timer := 0.0

func _physics_process(delta: float) -> void:
	var player := Game.instance.player
	var target_position: Vector2
	var sees_player := creature.position.distance_to(player.position) < view_radius
	
	match state:
		State.IDLE:
			target_position = creature.position
			if sees_player: state = State.FOLLOW
		State.FOLLOW:
			target_position = player.position
			if sees_player: follow_timer = 5.0 # "erinnere" dich an Player
			else: follow_timer -= delta # "vergiss" Player
			if follow_timer <= 0.0: state = State.IDLE # Vergessen? Zurück zu Idle
			if target_position.distance_to(creature.position) < 15:
				target_position = creature.position
	
	agent.target_position = target_position
