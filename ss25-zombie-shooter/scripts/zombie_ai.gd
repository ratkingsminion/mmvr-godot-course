extends Node

enum State { IDLE, FOLLOW, ATTACK }

@export var agent: NavigationAgent2D
@export var view_radius := 45.0
@export var attack_radius := 15.0

@onready var creature: CharacterBody2D = $".."
@onready var debug_label: Label = $"../Debug Label"
@onready var area_2d: Area2D = $Area2D
@onready var health: Health = $"../HealthComponent"

var fsm := SimpleFSM.create(State, self)
var follow_timer := 0.0
var attack_timer := 0.0

###

func _ready() -> void:
	health.on_hit.connect(_on_hit)
	fsm.state_changed.connect(func(from, to) -> void: debug_label.text = State.keys()[to].to_lower())
	fsm.set_state(State.FOLLOW)

### FSM - idle

func _physics_process_state_idle(delta: float) -> void:
	if _can_attack_player(): fsm.set_state(State.ATTACK)
	elif _sees_player(): fsm.set_state(State.FOLLOW)
	else: agent.target_position = creature.position

### FSM - follow

func _enter_state_follow(prev: State) -> void:
	follow_timer = 5.0

func _physics_process_state_follow(delta: float) -> void:
	if _sees_player(): follow_timer = 5.0 # "erinnere" dich an Player
	follow_timer -= get_physics_process_delta_time() # "vergiss" Player langsam wieder
	
	if follow_timer <= 0.0: fsm.set_state(State.IDLE) # Vergessen? Zurück zu Idle
	elif _can_attack_player(): fsm.set_state(State.ATTACK)
	else: agent.target_position = Game.instance.player.position

### FSM - attack

func _enter_state_attack(prev: State) -> void:
	attack_timer = 1.0
	if area_2d.overlaps_body(Game.instance.player):
		var health = Game.instance.player.find_child("HealthComponent")
		if health: health.hurt(1)

func _physics_process_state_attack(delta: float) -> void:
	attack_timer -= get_physics_process_delta_time()
	
	if attack_timer <= 0.0: fsm.set_state(State.IDLE)
	else: agent.target_position = creature.position

###

func _sees_player() -> bool:
	var player := Game.instance.player
	return creature.position.distance_to(player.position) < view_radius

func _can_attack_player() -> bool:
	var player := Game.instance.player
	return creature.position.distance_to(player.position) < attack_radius

### signals

func _on_hit() -> void:
	if fsm.get_state() in [ State.IDLE ]:
		fsm.set_state(State.FOLLOW)
		follow_timer = 10.0
