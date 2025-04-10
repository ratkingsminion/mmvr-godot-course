extends Node

enum State { IDLE, FOLLOW, ATTACK }

@export var agent: NavigationAgent2D
@export var view_radius := 45.0

@onready var creature: CharacterBody2D = $".."
@onready var debug_label: Label = $"../Debug Label"
@onready var area_2d: Area2D = $Area2D
@onready var health: Health = $"../HealthComponent"

var state: State = State.FOLLOW
var follow_timer := 0.0
var attack_timer := 0.0

func _ready() -> void:
	health.on_hit.connect(_on_hit)

func _physics_process(delta: float) -> void:
	var player := Game.instance.player
	var sees_player := creature.position.distance_to(player.position) < view_radius
	match state:
		State.IDLE: _idle(sees_player)
		State.FOLLOW: _follow(sees_player)
		State.ATTACK: _attack()
	debug_label.text = State.keys()[state].to_lower()

func _idle(sees_player: bool) -> void:
	var target_position := creature.position
	if sees_player: state = State.FOLLOW
	agent.target_position = target_position

func _follow(sees_player: bool) -> void:
	var target_position := Game.instance.player.position
	if sees_player or follow_timer <= 0.0: follow_timer = 5.0 # "erinnere" dich an Player
	else: follow_timer -= get_physics_process_delta_time() # "vergiss" Player
	if follow_timer <= 0.0: state = State.IDLE # Vergessen? Zurück zu Idle
	if target_position.distance_to(creature.position) < 15:
		state = State.ATTACK
	else:
		agent.target_position = target_position

func _attack() -> void:
	var target_position := creature.position
	if attack_timer <= 0.0: # führe Attacke aus - verletze Spieler
		attack_timer = 1.0
		if area_2d.overlaps_body(Game.instance.player):
			var health = Game.instance.player.find_child("HealthComponent")
			if health: health.hurt(1)
	else: # warte eine Sekunde
		attack_timer -= get_physics_process_delta_time()
	if attack_timer <= 0.0:
		state = State.IDLE
	agent.target_position = target_position

### signals

func _on_hit() -> void:
	if state in [ State.IDLE ]:
		state = State.FOLLOW
		follow_timer = 10.0
